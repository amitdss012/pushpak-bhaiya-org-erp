import { prisma } from "../../../lib/prisma.js";
import type {
  BillingCycle,
  OrgStatus,
  Prisma,
  Subscription,
  SubscriptionStatus,
} from "../../../generated/prisma/client.js";
import type {
  OrganizationDetailResponse,
  OrganizationListItem,
  PaginatedResult,
} from "../types/organization.types.js";
import type { OrgQueryParams } from "../validators/organization.validator.js";

export class OrganizationRepo {
  /**
   * Find an organization by slug.
   */
  async findBySlug(slug: string) {
    return prisma.organization.findUnique({
      where: { slug },
    });
  }

  /**
   * Find an organization by ID.
   */
  async findById(id: string) {
    return prisma.organization.findUnique({
      where: { id },
    });
  }

  /**
   * Check if a user with given email exists globally or in any organization.
   */
  async findUserByEmail(email: string) {
    return prisma.user.findFirst({
      where: { email },
    });
  }

  /**
   * Find an active or trialing subscription for an organization.
   */
  async findActiveSubscription(organizationId: string) {
    return prisma.subscription.findFirst({
      where: {
        organizationId,
        status: { in: ["ACTIVE", "TRIALING"] },
      },
      orderBy: { createdAt: "desc" },
      include: {
        plan: true,
      },
    });
  }

  /**
   * List organizations with pagination, search, and filters.
   */
  async findAll(query: OrgQueryParams): Promise<PaginatedResult<OrganizationListItem>> {
    const { page, limit, search, status, planId, sortBy, sortOrder } = query;
    const skip = (page - 1) * limit;

    const where: Prisma.OrganizationWhereInput = {
      deletedAt: null,
    };

    if (status) {
      where.status = status;
    }

    if (search) {
      where.OR = [
        { name: { contains: search, mode: "insensitive" } },
        { slug: { contains: search, mode: "insensitive" } },
        { email: { contains: search, mode: "insensitive" } },
      ];
    }

    if (planId) {
      where.subscriptions = {
        some: {
          planId,
          status: { in: ["ACTIVE", "TRIALING"] },
        },
      };
    }

    const [total, organizations] = await Promise.all([
      prisma.organization.count({ where }),
      prisma.organization.findMany({
        where,
        skip,
        take: limit,
        orderBy: { [sortBy]: sortOrder },
        include: {
          subscriptions: {
            where: { status: { in: ["ACTIVE", "TRIALING"] } },
            orderBy: { createdAt: "desc" },
            take: 1,
            include: {
              plan: {
                select: {
                  id: true,
                  name: true,
                  slug: true,
                  priceMonthly: true,
                  priceYearly: true,
                  currency: true,
                  maxBranches: true,
                  maxStudentsPerBranch: true,
                  maxTeachersPerBranch: true,
                  features: true,
                },
              },
            },
          },
          users: {
            where: { scope: "ORGANIZATION" },
            orderBy: { createdAt: "asc" },
            take: 1,
            select: {
              id: true,
              firstName: true,
              lastName: true,
              email: true,
              phone: true,
              status: true,
              createdAt: true,
            },
          },
          _count: {
            select: {
              branches: true,
              users: true,
            },
          },
        },
      }),
    ]);

    const totalPages = Math.ceil(total / limit);

    const formattedData: OrganizationListItem[] = organizations.map((org) => {
      const activeSub = org.subscriptions[0] || null;
      const ownerUser = org.users[0] || null;

      return {
        id: org.id,
        name: org.name,
        slug: org.slug,
        email: org.email,
        phone: org.phone,
        logo: org.logo,
        status: org.status,
        createdAt: org.createdAt,
        updatedAt: org.updatedAt,
        activeSubscription: activeSub
          ? {
              id: activeSub.id,
              planId: activeSub.planId,
              status: activeSub.status,
              billingCycle: activeSub.billingCycle,
              currentPeriodStart: activeSub.currentPeriodStart,
              currentPeriodEnd: activeSub.currentPeriodEnd,
              trialEndsAt: activeSub.trialEndsAt,
              plan: activeSub.plan,
            }
          : null,
        owner: ownerUser,
        _count: org._count,
      };
    });

    return {
      data: formattedData,
      pagination: {
        total,
        page,
        limit,
        totalPages,
        hasNextPage: page < totalPages,
        hasPrevPage: page > 1,
      },
    };
  }

  /**
   * Get detailed profile of an organization.
   */
  async getDetails(id: string): Promise<OrganizationDetailResponse | null> {
    const org = await prisma.organization.findUnique({
      where: { id },
      include: {
        subscriptions: {
          orderBy: { createdAt: "desc" },
          include: {
            plan: true,
          },
        },
        users: {
          where: { scope: "ORGANIZATION" },
          orderBy: { createdAt: "asc" },
          take: 1,
          select: {
            id: true,
            firstName: true,
            lastName: true,
            email: true,
            phone: true,
            status: true,
            createdAt: true,
          },
        },
        _count: {
          select: {
            branches: true,
            users: true,
          },
        },
      },
    });

    if (!org) return null;

    const activeSub =
      org.subscriptions.find((s) => s.status === "ACTIVE" || s.status === "TRIALING") || null;
    const ownerUser = org.users[0] || null;

    return {
      id: org.id,
      name: org.name,
      slug: org.slug,
      email: org.email,
      phone: org.phone,
      logo: org.logo,
      address: org.address,
      city: org.city,
      state: org.state,
      country: org.country,
      pincode: org.pincode,
      status: org.status,
      createdAt: org.createdAt,
      updatedAt: org.updatedAt,
      activeSubscription: activeSub
        ? {
            id: activeSub.id,
            planId: activeSub.planId,
            status: activeSub.status,
            billingCycle: activeSub.billingCycle,
            currentPeriodStart: activeSub.currentPeriodStart,
            currentPeriodEnd: activeSub.currentPeriodEnd,
            trialEndsAt: activeSub.trialEndsAt,
            plan: activeSub.plan,
          }
        : null,
      subscriptions: org.subscriptions.map((s) => ({
        id: s.id,
        status: s.status,
        billingCycle: s.billingCycle,
        currentPeriodStart: s.currentPeriodStart,
        currentPeriodEnd: s.currentPeriodEnd,
        trialEndsAt: s.trialEndsAt,
        cancelledAt: s.cancelledAt,
        plan: {
          id: s.plan.id,
          name: s.plan.name,
          slug: s.plan.slug,
        },
      })),
      owner: ownerUser,
      stats: {
        branchesCount: org._count.branches,
        usersCount: org._count.users,
      },
    };
  }

  /**
   * Update organization details.
   */
  async update(
    id: string,
    data: {
      name?: string | undefined;
      slug?: string | undefined;
      email?: string | null | undefined;
      phone?: string | null | undefined;
      logo?: string | null | undefined;
      address?: string | null | undefined;
      city?: string | null | undefined;
      state?: string | null | undefined;
      country?: string | undefined;
      pincode?: string | null | undefined;
      status?: OrgStatus | undefined;
    }
  ) {
    const updateData: Prisma.OrganizationUpdateInput = {};

    if (data.name !== undefined) updateData.name = data.name;
    if (data.slug !== undefined) updateData.slug = data.slug;
    if (data.email !== undefined) updateData.email = data.email;
    if (data.phone !== undefined) updateData.phone = data.phone;
    if (data.logo !== undefined) updateData.logo = data.logo;
    if (data.address !== undefined) updateData.address = data.address;
    if (data.city !== undefined) updateData.city = data.city;
    if (data.state !== undefined) updateData.state = data.state;
    if (data.country !== undefined) updateData.country = data.country;
    if (data.pincode !== undefined) updateData.pincode = data.pincode;
    if (data.status !== undefined) updateData.status = data.status;

    return prisma.organization.update({
      where: { id },
      data: updateData,
    });
  }

  /**
   * Update a subscription record.
   */
  async updateSubscription(
    id: string,
    data: {
      planId?: string | undefined;
      billingCycle?: BillingCycle | undefined;
      status?: SubscriptionStatus | undefined;
      currentPeriodEnd?: Date | undefined;
      trialEndsAt?: Date | null | undefined;
      cancelledAt?: Date | null | undefined;
    }
  ): Promise<Subscription> {
    const updateData: Prisma.SubscriptionUpdateInput = {};

    if (data.planId !== undefined) {
      updateData.plan = { connect: { id: data.planId } };
    }
    if (data.billingCycle !== undefined) updateData.billingCycle = data.billingCycle;
    if (data.status !== undefined) updateData.status = data.status;
    if (data.currentPeriodEnd !== undefined) updateData.currentPeriodEnd = data.currentPeriodEnd;
    if (data.trialEndsAt !== undefined) updateData.trialEndsAt = data.trialEndsAt;
    if (data.cancelledAt !== undefined) updateData.cancelledAt = data.cancelledAt;

    return prisma.subscription.update({
      where: { id },
      data: updateData,
    });
  }

  /**
   * Create a new subscription record for an organization.
   */
  async createSubscription(data: {
    organizationId: string;
    planId: string;
    billingCycle: BillingCycle;
    status: SubscriptionStatus;
    currentPeriodStart: Date;
    currentPeriodEnd: Date;
    trialEndsAt?: Date | null | undefined;
  }): Promise<Subscription> {
    const createData: Prisma.SubscriptionCreateInput = {
      organization: { connect: { id: data.organizationId } },
      plan: { connect: { id: data.planId } },
      billingCycle: data.billingCycle,
      status: data.status,
      currentPeriodStart: data.currentPeriodStart,
      currentPeriodEnd: data.currentPeriodEnd,
      trialEndsAt: data.trialEndsAt ?? null,
    };

    return prisma.subscription.create({
      data: createData,
    });
  }
}

export const organizationRepo = new OrganizationRepo();
