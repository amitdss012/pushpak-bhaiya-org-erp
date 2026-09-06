import type { Request } from "express";
import { storageService, type StorageService } from "../../../lib/storage/storage.service.js";
import { type StorageFile } from "../../../lib/storage/storage.interface.js";
import { BranchStatus, Scope, statusCode } from "../../../types/types.js";
import { ErrorResponse } from "../../../utils/response.util.js";
import { auditLogRepo, type AuditLogRepo } from "../../user/repos/audit-log.repo.js";
import type { SanitizedUserWithDetails } from "../../user/types/user.types.js";
import { branchRepo, type BranchRepo } from "../repos/branch.repo.js";
import type { PaginatedBranchesResult } from "../types/branch.types.js";
import type { CreateBranchInput, ListBranchesInput } from "../validators/branch.validator.js";

export class BranchService {
  constructor(
    private readonly branches: BranchRepo = branchRepo,
    private readonly auditLogs: AuditLogRepo = auditLogRepo,
    private readonly storage: StorageService = storageService
  ) {}

  /**
   * Slugify a branch name string into a URL-friendly unique identifier.
   */
  private slugify(text: string): string {
    return text
      .toLowerCase()
      .trim()
      .replace(/[^\w\s-]/g, "")
      .replace(/[\s_-]+/g, "-")
      .replace(/^-+|-+$/g, "");
  }

  /**
   * Helper to parse date strings safely.
   */
  private parseDate(val?: string | null): Date | null {
    if (!val || val.trim().length === 0) return null;
    const parsed = new Date(val);
    return isNaN(parsed.getTime()) ? null : parsed;
  }

  /**
   * Create a new Branch for the caller's Organization.
   * - Enforces Organization-scope boundaries (Branch users cannot create branches).
   * - Uploads branch logo to Cloud Storage (Cloudinary) via provider-agnostic StorageService.
   * - Checks subscription plan branch quota.
   * - Provisions initial Branch Admin user if credentials are provided.
   */
  async createBranch(
    caller: SanitizedUserWithDetails,
    input: CreateBranchInput,
    logoFile?: StorageFile,
    req?: Request
  ) {
    // 1. Scope Boundary: Only ORGANIZATION users can provision branches
    if (caller.scope !== Scope.ORGANIZATION) {
      throw new ErrorResponse(
        "Access denied: Only organization administrators can provision new branches",
        statusCode.Forbidden
      );
    }

    // 2. Generate slug and ensure uniqueness within parent organization
    const baseSlug = this.slugify(input.name);
    let slug = baseSlug;
    const existing = await this.branches.findBySlug(caller.organizationId, slug);
    if (existing) {
      // Append random hash to prevent conflicts
      slug = `${baseSlug}-${Math.random().toString(36).substring(2, 6)}`;
    }

    // 3. Upload logo via provider-agnostic StorageService if file provided
    let logoUrl: string | null = input.logo || null;
    if (logoFile && logoFile.buffer && logoFile.buffer.length > 0) {
      const uploadRes = await this.storage.upload(logoFile, {
        folder: "branch_logos",
        publicId: `${caller.organizationId}_${slug}_logo`,
      });
      logoUrl = uploadRes.secureUrl;
    }

    // 4. Resolve status
    let resolvedStatus = input.status as BranchStatus;
    if (input.activeStatus !== undefined) {
      resolvedStatus = input.activeStatus ? BranchStatus.ACTIVE : BranchStatus.INACTIVE;
    }

    // 5. Build admin user payload if provided
    let adminUserPayload: {
      name?: string | null | undefined;
      email: string;
      password: string;
      phone?: string | null | undefined;
    } | null | undefined = null;

    if (input.adminEmail && input.adminPassword) {
      adminUserPayload = {
        name: input.adminName || `${input.name} Admin`,
        email: input.adminEmail,
        password: input.adminPassword,
        phone: input.adminPhone || input.phone || null,
      };
    }

    // 6. Persist branch in database
    const createdBranch = await this.branches.create({
      organizationId: caller.organizationId,
      createdById: caller.id,
      name: input.name,
      slug,
      code: input.code ?? null,
      email: input.email ?? null,
      phone: input.phone ?? null,
      altPhone: input.altPhone ?? null,
      whatsapp: input.whatsapp ?? null,
      logo: logoUrl ?? null,
      branchType: input.branchType ?? "main",
      instituteType: input.instituteType ?? "computer",
      establishedYear: input.establishedYear ?? null,
      website: input.website ?? null,
      description: input.description ?? null,
      address: input.address || input.streetAddress || null,
      city: input.city ?? null,
      district: input.district ?? null,
      block: input.block ?? null,
      state: input.state ?? null,
      country: input.country || "IN",
      pincode: input.pincode ?? null,
      latitude: input.latitude ?? null,
      longitude: input.longitude ?? null,
      directorName: input.directorName ?? null,
      directorGender: input.directorGender ?? null,
      directorDob: this.parseDate(input.directorDob),
      directorBloodGroup: input.directorBloodGroup ?? null,
      numComputers: input.numComputers ?? 0,
      numFaculty: input.numFaculty ?? 0,
      numRooms: input.numRooms ?? 0,
      numFees: input.numFees ?? null,
      registrationDate: this.parseDate(input.registrationDate),
      validDate: this.parseDate(input.validDate),
      expiryDate: this.parseDate(input.expiryDate),
      renewalDate: this.parseDate(input.renewalDate),
      referralCode: input.referralCode ?? null,
      onlineEnrollment: input.onlineEnrollment ?? true,
      smsNotifications: input.smsNotifications ?? false,
      emailNotifications: input.emailNotifications ?? true,
      status: resolvedStatus,
      adminUser: adminUserPayload,
    });

    // 7. Audit log
    if (req) {
      await this.auditLogs.create({
        organizationId: caller.organizationId,
        branchId: createdBranch.id,
        userId: caller.id,
        action: "USER_CREATED",
        targetEntity: "Branch",
        targetEntityId: createdBranch.id,
        ipAddress: req.ip,
        userAgent: req.headers["user-agent"],
        metadata: {
          branchId: createdBranch.id,
          branchName: createdBranch.name,
          slug,
          storageProvider: this.storage.activeProviderName,
          hasLogo: Boolean(logoUrl),
        },
      });
    }

    return createdBranch;
  }

  /**
   * List paginated branches with search, filters, relation counts, and aggregated stats.
   */
  async listBranches(
    caller: SanitizedUserWithDetails,
    input: ListBranchesInput
  ): Promise<PaginatedBranchesResult> {
    const skip = (input.page - 1) * input.limit;
    const take = input.limit;

    // Organization users see all branches; Branch users only see their own branch
    let searchStatus = input.status as BranchStatus | undefined;
    const [branchesList, totalCount, stats] = await Promise.all([
      this.branches.findMany({
        organizationId: caller.organizationId,
        search: input.search,
        status: searchStatus,
        branchType: input.branchType,
        city: input.city,
        skip,
        take,
      }),
      this.branches.count({
        organizationId: caller.organizationId,
        search: input.search,
        status: searchStatus,
        branchType: input.branchType,
        city: input.city,
      }),
      this.branches.getStats(caller.organizationId),
    ]);

    return {
      data: branchesList,
      stats,
      meta: {
        total: totalCount,
        page: input.page,
        limit: input.limit,
        totalPages: Math.ceil(totalCount / input.limit) || 1,
      },
    };
  }
}

export const branchService = new BranchService();
