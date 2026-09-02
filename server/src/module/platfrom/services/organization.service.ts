import bcrypt from "bcrypt";
import { prisma } from "../../../lib/prisma.js";
import type {
  BillingCycle,
  Organization,
  Subscription,
  SubscriptionPlan,
  SubscriptionStatus,
} from "../../../types/types.js";
import { statusCode } from "../../../types/types.js";
import { ErrorResponse } from "../../../utils/response.util.js";
import { organizationRepo, type OrganizationRepo } from "../repos/organization.repo.js";
import { planRepo, type PlanRepo } from "../repos/plan.repo.js";
import type {
  OrganizationDetailResponse,
  OrganizationListItem,
  PaginatedResult,
  SanitizedOrgOwner,
} from "../types/organization.types.js";
import type {
  OnboardOrganizationInput,
  OrgQueryParams,
  UpdateOrganizationInput,
  UpdateOrgSubscriptionInput,
} from "../validators/organization.validator.js";

export class OrganizationService {
  constructor(
    private readonly repo: OrganizationRepo = organizationRepo,
    private readonly planRepository: PlanRepo = planRepo
  ) {}

  /**
   * Helper utility to convert a string to a URL-friendly slug.
   */
  private generateSlug(text: string): string {
    return text
      .toLowerCase()
      .trim()
      .replace(/[^\w\s-]/g, "")
      .replace(/[\s_-]+/g, "-")
      .replace(/^-+|-+$/g, "");
  }

  /**
   * Helper to compute end date for a billing cycle from a start date.
   */
  private calculatePeriodEnd(
    startDate: Date,
    billingCycle: BillingCycle,
    status: SubscriptionStatus,
    trialDays = 14
  ): { periodEnd: Date; trialEndsAt: Date | null } {
    if (status === "TRIALING") {
      const trialEnd = new Date(startDate.getTime() + trialDays * 24 * 60 * 60 * 1000);
      return {
        periodEnd: trialEnd,
        trialEndsAt: trialEnd,
      };
    }

    const end = new Date(startDate);
    switch (billingCycle) {
      case "YEARLY":
        end.setFullYear(end.getFullYear() + 1);
        break;
      case "QUARTERLY":
        end.setMonth(end.getMonth() + 3);
        break;
      case "MONTHLY":
      default:
        end.setMonth(end.getMonth() + 1);
        break;
    }

    return {
      periodEnd: end,
      trialEndsAt: null,
    };
  }

  /**
   * Onboard an organization with initial subscription & owner user atomically.
   */
  async onboardOrganization(input: OnboardOrganizationInput): Promise<{
    organization: Organization;
    subscription: Subscription & { plan: SubscriptionPlan };
    owner: SanitizedOrgOwner;
  }> {
    const orgSlug = input.organization.slug || this.generateSlug(input.organization.name);

    // 1. Check organization slug uniqueness
    const existingOrg = await this.repo.findBySlug(orgSlug);
    if (existingOrg) {
      throw new ErrorResponse(
        `Organization with slug '${orgSlug}' already exists`,
        statusCode.Conflict
      );
    }

    // 2. Check if owner email is already registered
    const existingUser = await this.repo.findUserByEmail(input.owner.email);
    if (existingUser) {
      throw new ErrorResponse(
        `User with email '${input.owner.email}' is already registered`,
        statusCode.Conflict
      );
    }

    // 3. Verify subscription plan existence and active status
    const plan = await this.planRepository.findById(input.subscription.planId);
    if (!plan) {
      throw new ErrorResponse("Selected subscription plan was not found", statusCode.Not_Found);
    }

    if (!plan.isActive) {
      throw new ErrorResponse(
        "Selected subscription plan is inactive and cannot be assigned to new organizations",
        statusCode.Bad_Request
      );
    }

    // 4. Calculate subscription period
    const startDate = new Date();
    const { periodEnd: calculatedEnd, trialEndsAt } = this.calculatePeriodEnd(
      startDate,
      input.subscription.billingCycle,
      input.subscription.status,
      input.subscription.trialDays
    );

    const currentPeriodEnd = input.subscription.customPeriodEnd
      ? new Date(input.subscription.customPeriodEnd)
      : calculatedEnd;

    // 5. Hash owner password
    const passwordHash = await bcrypt.hash(input.owner.password, 10);

    // 6. Execute ACID transaction
    const result = await prisma.$transaction(async (tx) => {
      // 6a. Create Organization
      const organization = await tx.organization.create({
        data: {
          name: input.organization.name,
          slug: orgSlug,
          email: input.organization.email ?? null,
          phone: input.organization.phone ?? null,
          logo: input.organization.logo ?? null,
          address: input.organization.address ?? null,
          city: input.organization.city ?? null,
          state: input.organization.state ?? null,
          country: input.organization.country || "IN",
          pincode: input.organization.pincode ?? null,
          status: "ACTIVE",
        },
      });

      // 6b. Create Subscription
      const subscription = await tx.subscription.create({
        data: {
          organizationId: organization.id,
          planId: plan.id,
          status: input.subscription.status,
          billingCycle: input.subscription.billingCycle,
          currentPeriodStart: startDate,
          currentPeriodEnd,
          trialEndsAt: trialEndsAt ?? null,
        },
        include: {
          plan: true,
        },
      });

      // 6c. Create Owner Role for Organization
      const ownerRole = await tx.role.create({
        data: {
          organizationId: organization.id,
          name: "Owner",
          slug: "owner",
          description: "Full administrative access to the organization",
          scope: "ORGANIZATION",
          isSystemRole: true,
        },
      });

      // 6d. Find Organization-scoped permissions and attach to Owner role
      const orgPermissions = await tx.permission.findMany({
        where: {
          allowedScopes: {
            has: "ORGANIZATION",
          },
        },
      });

      if (orgPermissions.length > 0) {
        await tx.rolePermission.createMany({
          data: orgPermissions.map((perm) => ({
            roleId: ownerRole.id,
            permissionId: perm.id,
          })),
          skipDuplicates: true,
        });
      }

      // 6e. Create Owner User
      const ownerUser = await tx.user.create({
        data: {
          organizationId: organization.id,
          scope: "ORGANIZATION",
          firstName: input.owner.firstName,
          lastName: input.owner.lastName ?? null,
          email: input.owner.email,
          passwordHash,
          phone: input.owner.phone ?? null,
          status: "ACTIVE",
          emailVerifiedAt: new Date(),
        },
      });

      // 6f. Assign Owner Role to User
      await tx.userRole.create({
        data: {
          userId: ownerUser.id,
          roleId: ownerRole.id,
        },
      });

      // 6g. Create Audit Log
      await tx.auditLog.create({
        data: {
          organizationId: organization.id,
          userId: ownerUser.id,
          action: "USER_CREATED",
          targetEntity: "Organization",
          targetEntityId: organization.id,
          metadata: {
            action: "ORGANIZATION_ONBOARDED",
            planName: plan.name,
            planSlug: plan.slug,
          },
        },
      });

      const sanitizedOwner: SanitizedOrgOwner = {
        id: ownerUser.id,
        firstName: ownerUser.firstName,
        lastName: ownerUser.lastName ?? null,
        email: ownerUser.email,
        phone: ownerUser.phone ?? null,
        status: ownerUser.status,
        createdAt: ownerUser.createdAt,
      };

      return {
        organization,
        subscription,
        owner: sanitizedOwner,
      };
    });

    return result;
  }

  /**
   * List organizations with pagination and filtering.
   */
  async getAllOrganizations(query: OrgQueryParams): Promise<PaginatedResult<OrganizationListItem>> {
    return this.repo.findAll(query);
  }

  /**
   * Get detailed organization profile by ID.
   */
  async getOrganizationById(id: string): Promise<OrganizationDetailResponse> {
    const org = await this.repo.getDetails(id);
    if (!org) {
      throw new ErrorResponse("Organization not found", statusCode.Not_Found);
    }
    return org;
  }

  /**
   * Update organization profile and status.
   */
  async updateOrganization(id: string, input: UpdateOrganizationInput): Promise<Organization> {
    const org = await this.repo.findById(id);
    if (!org) {
      throw new ErrorResponse("Organization not found", statusCode.Not_Found);
    }

    if (input.slug && input.slug !== org.slug) {
      const existingSlug = await this.repo.findBySlug(input.slug);
      if (existingSlug && existingSlug.id !== id) {
        throw new ErrorResponse(
          `Organization with slug '${input.slug}' already exists`,
          statusCode.Conflict
        );
      }
    }

    return this.repo.update(id, input);
  }

  /**
   * Update or upgrade an organization's subscription plan and status.
   */
  async updateOrgSubscription(
    organizationId: string,
    input: UpdateOrgSubscriptionInput
  ): Promise<Subscription & { plan: SubscriptionPlan }> {
    const org = await this.repo.findById(organizationId);
    if (!org) {
      throw new ErrorResponse("Organization not found", statusCode.Not_Found);
    }

    if (input.planId) {
      const targetPlan = await this.planRepository.findById(input.planId);
      if (!targetPlan) {
        throw new ErrorResponse("Target subscription plan not found", statusCode.Not_Found);
      }
    }

    const currentSub = await this.repo.findActiveSubscription(organizationId);

    if (currentSub) {
      const billingCycle = input.billingCycle || currentSub.billingCycle;
      const status = input.status || currentSub.status;

      let currentPeriodEnd = currentSub.currentPeriodEnd;
      let trialEndsAt = currentSub.trialEndsAt;

      if (input.currentPeriodEnd) {
        currentPeriodEnd = new Date(input.currentPeriodEnd);
      } else if (input.billingCycle && input.billingCycle !== currentSub.billingCycle) {
        const { periodEnd, trialEndsAt: newTrialEnd } = this.calculatePeriodEnd(
          currentSub.currentPeriodStart,
          billingCycle,
          status
        );
        currentPeriodEnd = periodEnd;
        trialEndsAt = newTrialEnd;
      }

      if (input.trialEndsAt !== undefined) {
        trialEndsAt = input.trialEndsAt ? new Date(input.trialEndsAt) : null;
      }

      const updated = await this.repo.updateSubscription(currentSub.id, {
        planId: input.planId,
        billingCycle: input.billingCycle,
        status: input.status,
        currentPeriodEnd,
        trialEndsAt,
        cancelledAt: input.status === "CANCELLED" ? new Date() : undefined,
      });

      const fullSub = await prisma.subscription.findUnique({
        where: { id: updated.id },
        include: { plan: true },
      });

      return fullSub!;
    } else {
      if (!input.planId) {
        throw new ErrorResponse(
          "Plan ID is required when setting an initial or renewed subscription",
          statusCode.Bad_Request
        );
      }

      const billingCycle = input.billingCycle || "MONTHLY";
      const status = input.status || "ACTIVE";
      const startDate = new Date();
      const { periodEnd, trialEndsAt } = this.calculatePeriodEnd(startDate, billingCycle, status);

      const created = await this.repo.createSubscription({
        organizationId,
        planId: input.planId,
        billingCycle,
        status,
        currentPeriodStart: startDate,
        currentPeriodEnd: input.currentPeriodEnd ? new Date(input.currentPeriodEnd) : periodEnd,
        trialEndsAt: input.trialEndsAt ? new Date(input.trialEndsAt) : trialEndsAt,
      });

      const fullSub = await prisma.subscription.findUnique({
        where: { id: created.id },
        include: { plan: true },
      });

      return fullSub!;
    }
  }
}

export const organizationService = new OrganizationService();
