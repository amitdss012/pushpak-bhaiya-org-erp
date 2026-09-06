import bcrypt from "bcryptjs";
import { prisma } from "../../../lib/prisma.js";
import { BranchStatus, Scope } from "../../../types/types.js";
import type { BranchStatsResult, BranchWithDetails } from "../types/branch.types.js";

export class BranchRepo {
  /**
   * Find branch by organizationId and slug (unique constraint boundary).
   */
  async findBySlug(organizationId: string, slug: string) {
    return prisma.branch.findFirst({
      where: {
        organizationId,
        slug,
        deletedAt: null,
      },
    });
  }

  /**
   * Find branch by ID within an organization.
   */
  async findById(id: string, organizationId: string) {
    return prisma.branch.findFirst({
      where: {
        id,
        organizationId,
        deletedAt: null,
      },
      include: {
        _count: {
          select: {
            users: true,
            students: true,
            teachers: true,
          },
        },
        createdBy: {
          select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
          },
        },
      },
    });
  }

  /**
   * Create a new branch with optional initial admin user provisioning in an ACID transaction.
   */
  async create(data: {
    organizationId: string;
    createdById?: string | null | undefined;
    name: string;
    slug: string;
    code?: string | null | undefined;
    email?: string | null | undefined;
    phone?: string | null | undefined;
    altPhone?: string | null | undefined;
    whatsapp?: string | null | undefined;
    logo?: string | null | undefined;
    branchType?: string | null | undefined;
    instituteType?: string | null | undefined;
    establishedYear?: string | null | undefined;
    website?: string | null | undefined;
    description?: string | null | undefined;
    address?: string | null | undefined;
    city?: string | null | undefined;
    district?: string | null | undefined;
    block?: string | null | undefined;
    state?: string | null | undefined;
    country?: string | null | undefined;
    pincode?: string | null | undefined;
    latitude?: number | null | undefined;
    longitude?: number | null | undefined;
    directorName?: string | null | undefined;
    directorGender?: string | null | undefined;
    directorDob?: Date | null | undefined;
    directorBloodGroup?: string | null | undefined;
    numComputers?: number | undefined;
    numFaculty?: number | undefined;
    numRooms?: number | undefined;
    numFees?: number | null | undefined;
    registrationDate?: Date | null | undefined;
    validDate?: Date | null | undefined;
    expiryDate?: Date | null | undefined;
    renewalDate?: Date | null | undefined;
    referralCode?: string | null | undefined;
    onlineEnrollment?: boolean | undefined;
    smsNotifications?: boolean | undefined;
    emailNotifications?: boolean | undefined;
    status: BranchStatus;
    adminUser?: {
      name?: string | null | undefined;
      email: string;
      password: string;
      phone?: string | null | undefined;
    } | null | undefined;
  }): Promise<BranchWithDetails> {
    return prisma.$transaction(async (tx) => {
      // 1. Create the Branch entity
      const branch = await tx.branch.create({
        data: {
          organizationId: data.organizationId,
          createdById: data.createdById ?? null,
          name: data.name,
          slug: data.slug,
          code: data.code ?? null,
          email: data.email ?? null,
          phone: data.phone ?? null,
          altPhone: data.altPhone ?? null,
          whatsapp: data.whatsapp ?? null,
          logo: data.logo ?? null,
          branchType: data.branchType ?? "main",
          instituteType: data.instituteType ?? "computer",
          establishedYear: data.establishedYear ?? null,
          website: data.website ?? null,
          description: data.description ?? null,
          address: data.address ?? null,
          city: data.city ?? null,
          district: data.district ?? null,
          block: data.block ?? null,
          state: data.state ?? null,
          country: data.country ?? "IN",
          pincode: data.pincode ?? null,
          latitude: data.latitude ?? null,
          longitude: data.longitude ?? null,
          directorName: data.directorName ?? null,
          directorGender: data.directorGender ?? null,
          directorDob: data.directorDob ?? null,
          directorBloodGroup: data.directorBloodGroup ?? null,
          numComputers: data.numComputers ?? 0,
          numFaculty: data.numFaculty ?? 0,
          numRooms: data.numRooms ?? 0,
          numFees: data.numFees ?? null,
          registrationDate: data.registrationDate ?? null,
          validDate: data.validDate ?? null,
          expiryDate: data.expiryDate ?? null,
          renewalDate: data.renewalDate ?? null,
          referralCode: data.referralCode ?? null,
          onlineEnrollment: data.onlineEnrollment ?? true,
          smsNotifications: data.smsNotifications ?? false,
          emailNotifications: data.emailNotifications ?? true,
          status: data.status,
        },
      });

      // 2. Optionally provision initial Branch Admin user if credentials provided
      if (data.adminUser && data.adminUser.email && data.adminUser.password) {
        const hashedPassword = await bcrypt.hash(data.adminUser.password, 10);
        const nameParts = (data.adminUser.name || "Branch Administrator").trim().split(" ");
        const firstName = nameParts[0] || "Branch";
        const lastName = nameParts.length > 1 ? nameParts.slice(1).join(" ") : "Admin";

        // Create or locate a default Branch Admin role for this branch
        let branchAdminRole = await tx.role.findFirst({
          where: {
            organizationId: data.organizationId,
            branchId: branch.id,
            slug: "branch-admin",
            deletedAt: null,
          },
        });

        if (!branchAdminRole) {
          branchAdminRole = await tx.role.create({
            data: {
              organizationId: data.organizationId,
              branchId: branch.id,
              scope: Scope.BRANCH,
              name: "Branch Administrator",
              slug: "branch-admin",
              description: `Default administrative role for ${branch.name}`,
            },
          });
        }

        // Provision User
        const adminUser = await tx.user.create({
          data: {
            organizationId: data.organizationId,
            branchId: branch.id,
            scope: Scope.BRANCH,
            firstName,
            lastName,
            email: data.adminUser.email.toLowerCase().trim(),
            passwordHash: hashedPassword,
            phone: data.adminUser.phone ?? null,
          },
        });

        // Assign Role
        await tx.userRole.create({
          data: {
            userId: adminUser.id,
            roleId: branchAdminRole.id,
          },
        });
      }

      // Return created branch with relation counts
      return tx.branch.findUniqueOrThrow({
        where: { id: branch.id },
        include: {
          _count: {
            select: {
              users: true,
              students: true,
              teachers: true,
            },
          },
          createdBy: {
            select: {
              id: true,
              email: true,
              firstName: true,
              lastName: true,
            },
          },
        },
      });
    });
  }

  /**
   * Find paginated branches with search, filters, and relation counts.
   */
  async findMany(filter: {
    organizationId: string;
    search?: string | undefined;
    status?: BranchStatus | undefined;
    branchType?: string | undefined;
    city?: string | undefined;
    skip: number;
    take: number;
  }): Promise<BranchWithDetails[]> {
    const where: any = {
      organizationId: filter.organizationId,
      deletedAt: null,
    };

    if (filter.status) {
      where.status = filter.status;
    }

    if (filter.branchType) {
      where.branchType = { equals: filter.branchType, mode: "insensitive" };
    }

    if (filter.city) {
      where.city = { contains: filter.city, mode: "insensitive" };
    }

    if (filter.search) {
      where.OR = [
        { name: { contains: filter.search, mode: "insensitive" } },
        { code: { contains: filter.search, mode: "insensitive" } },
        { city: { contains: filter.search, mode: "insensitive" } },
        { state: { contains: filter.search, mode: "insensitive" } },
        { email: { contains: filter.search, mode: "insensitive" } },
        { phone: { contains: filter.search, mode: "insensitive" } },
        { directorName: { contains: filter.search, mode: "insensitive" } },
      ];
    }

    return prisma.branch.findMany({
      where,
      skip: filter.skip,
      take: filter.take,
      orderBy: { createdAt: "desc" },
      include: {
        _count: {
          select: {
            users: true,
            students: true,
            teachers: true,
          },
        },
        createdBy: {
          select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
          },
        },
      },
    });
  }

  /**
   * Count branches matching filter conditions.
   */
  async count(filter: {
    organizationId: string;
    search?: string | undefined;
    status?: BranchStatus | undefined;
    branchType?: string | undefined;
    city?: string | undefined;
  }): Promise<number> {
    const where: any = {
      organizationId: filter.organizationId,
      deletedAt: null,
    };

    if (filter.status) {
      where.status = filter.status;
    }

    if (filter.branchType) {
      where.branchType = { equals: filter.branchType, mode: "insensitive" };
    }

    if (filter.city) {
      where.city = { contains: filter.city, mode: "insensitive" };
    }

    if (filter.search) {
      where.OR = [
        { name: { contains: filter.search, mode: "insensitive" } },
        { code: { contains: filter.search, mode: "insensitive" } },
        { city: { contains: filter.search, mode: "insensitive" } },
        { state: { contains: filter.search, mode: "insensitive" } },
        { email: { contains: filter.search, mode: "insensitive" } },
        { phone: { contains: filter.search, mode: "insensitive" } },
        { directorName: { contains: filter.search, mode: "insensitive" } },
      ];
    }

    return prisma.branch.count({ where });
  }

  /**
   * Aggregate branch metrics for organization summary cards.
   */
  async getStats(organizationId: string): Promise<BranchStatsResult> {
    const [totalBranches, activeBranches, inactiveBranches, totalStudents, totalTeachers] =
      await Promise.all([
        prisma.branch.count({
          where: { organizationId, deletedAt: null },
        }),
        prisma.branch.count({
          where: { organizationId, status: BranchStatus.ACTIVE, deletedAt: null },
        }),
        prisma.branch.count({
          where: {
            organizationId,
            status: { in: [BranchStatus.INACTIVE, BranchStatus.SUSPENDED] },
            deletedAt: null,
          },
        }),
        prisma.student.count({
          where: {
            branch: { organizationId, deletedAt: null },
            deletedAt: null,
          },
        }),
        prisma.teacher.count({
          where: {
            branch: { organizationId, deletedAt: null },
            deletedAt: null,
          },
        }),
      ]);

    return {
      totalBranches,
      activeBranches,
      inactiveBranches,
      totalStudents,
      totalStaff: totalTeachers,
    };
  }
}

export const branchRepo = new BranchRepo();
