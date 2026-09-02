import { prisma } from "../../../lib/prisma.js";
import type { Prisma, SubscriptionPlan } from "../../../generated/prisma/client.js";
import type { PlanFilterOptions, SubscriptionPlanWithCount } from "../types/plan.types.js";

export class PlanRepo {
  /**
   * Create a new subscription plan.
   */
  async create(data: {
    name: string;
    slug: string;
    description?: string | null | undefined;
    priceMonthly: number;
    priceYearly: number;
    currency: string;
    maxBranches: number;
    maxStudentsPerBranch: number;
    maxTeachersPerBranch: number;
    features?: any;
    isActive?: boolean | undefined;
    sortOrder?: number | undefined;
  }): Promise<SubscriptionPlan> {
    const createData: Prisma.SubscriptionPlanCreateInput = {
      name: data.name,
      slug: data.slug,
      description: data.description ?? null,
      priceMonthly: data.priceMonthly,
      priceYearly: data.priceYearly,
      currency: data.currency,
      maxBranches: data.maxBranches,
      maxStudentsPerBranch: data.maxStudentsPerBranch,
      maxTeachersPerBranch: data.maxTeachersPerBranch,
      features: data.features ?? {},
      isActive: data.isActive ?? true,
      sortOrder: data.sortOrder ?? 0,
    };

    return prisma.subscriptionPlan.create({
      data: createData,
    });
  }

  /**
   * Find a subscription plan by its ID.
   */
  async findById(id: string): Promise<SubscriptionPlanWithCount | null> {
    return prisma.subscriptionPlan.findUnique({
      where: { id },
      include: {
        _count: {
          select: {
            subscriptions: true,
          },
        },
      },
    });
  }

  /**
   * Find a subscription plan by its unique slug.
   */
  async findBySlug(slug: string): Promise<SubscriptionPlan | null> {
    return prisma.subscriptionPlan.findUnique({
      where: { slug },
    });
  }

  /**
   * Find a subscription plan by its unique name.
   */
  async findByName(name: string): Promise<SubscriptionPlan | null> {
    return prisma.subscriptionPlan.findUnique({
      where: { name },
    });
  }

  /**
   * List all subscription plans ordered by sortOrder ascending, then createdAt ascending.
   * Optionally filtered by isActive.
   */
  async findAll(filters?: PlanFilterOptions): Promise<SubscriptionPlanWithCount[]> {
    const whereClause: Prisma.SubscriptionPlanWhereInput = {};
    if (filters?.isActive !== undefined) {
      whereClause.isActive = filters.isActive;
    }

    return prisma.subscriptionPlan.findMany({
      where: whereClause,
      orderBy: [{ sortOrder: "asc" }, { createdAt: "asc" }],
      include: {
        _count: {
          select: {
            subscriptions: true,
          },
        },
      },
    });
  }

  /**
   * Update a subscription plan.
   */
  async update(
    id: string,
    data: {
      name?: string | undefined;
      slug?: string | undefined;
      description?: string | null | undefined;
      priceMonthly?: number | undefined;
      priceYearly?: number | undefined;
      currency?: string | undefined;
      maxBranches?: number | undefined;
      maxStudentsPerBranch?: number | undefined;
      maxTeachersPerBranch?: number | undefined;
      features?: any;
      isActive?: boolean | undefined;
      sortOrder?: number | undefined;
    }
  ): Promise<SubscriptionPlan> {
    const updateData: Prisma.SubscriptionPlanUpdateInput = {};

    if (data.name !== undefined) updateData.name = data.name;
    if (data.slug !== undefined) updateData.slug = data.slug;
    if (data.description !== undefined) updateData.description = data.description;
    if (data.priceMonthly !== undefined) updateData.priceMonthly = data.priceMonthly;
    if (data.priceYearly !== undefined) updateData.priceYearly = data.priceYearly;
    if (data.currency !== undefined) updateData.currency = data.currency;
    if (data.maxBranches !== undefined) updateData.maxBranches = data.maxBranches;
    if (data.maxStudentsPerBranch !== undefined)
      updateData.maxStudentsPerBranch = data.maxStudentsPerBranch;
    if (data.maxTeachersPerBranch !== undefined)
      updateData.maxTeachersPerBranch = data.maxTeachersPerBranch;
    if (data.features !== undefined) updateData.features = data.features;
    if (data.isActive !== undefined) updateData.isActive = data.isActive;
    if (data.sortOrder !== undefined) updateData.sortOrder = data.sortOrder;

    return prisma.subscriptionPlan.update({
      where: { id },
      data: updateData,
    });
  }

  /**
   * Count how many active or trialing subscriptions are linked to this plan.
   */
  async countActiveSubscriptions(planId: string): Promise<number> {
    return prisma.subscription.count({
      where: {
        planId,
        status: { in: ["ACTIVE", "TRIALING"] },
      },
    });
  }

  /**
   * Delete a subscription plan by ID.
   */
  async delete(id: string): Promise<SubscriptionPlan> {
    return prisma.subscriptionPlan.delete({
      where: { id },
    });
  }
}

export const planRepo = new PlanRepo();
