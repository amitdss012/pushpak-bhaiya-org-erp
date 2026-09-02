import type { SubscriptionPlan } from "../../../types/types.js";
import { statusCode } from "../../../types/types.js";
import { ErrorResponse } from "../../../utils/response.util.js";
import { planRepo, type PlanRepo } from "../repos/plan.repo.js";
import type { PlanFilterOptions, SubscriptionPlanWithCount } from "../types/plan.types.js";
import type {
  CreatePlanInput,
  PlanQueryParams,
  UpdatePlanInput,
} from "../validators/plan.validator.js";

export class PlanService {
  constructor(private readonly repo: PlanRepo = planRepo) {}

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
   * Create a new subscription plan.
   */
  async createPlan(input: CreatePlanInput): Promise<SubscriptionPlan> {
    const slug = input.slug || this.generateSlug(input.name);

    const existingSlug = await this.repo.findBySlug(slug);
    if (existingSlug) {
      throw new ErrorResponse(
        `Subscription plan with slug '${slug}' already exists`,
        statusCode.Conflict
      );
    }

    const existingName = await this.repo.findByName(input.name);
    if (existingName) {
      throw new ErrorResponse(
        `Subscription plan with name '${input.name}' already exists`,
        statusCode.Conflict
      );
    }

    return this.repo.create({
      name: input.name,
      slug,
      description: input.description ?? null,
      priceMonthly: input.priceMonthly,
      priceYearly: input.priceYearly,
      currency: input.currency,
      maxBranches: input.maxBranches,
      maxStudentsPerBranch: input.maxStudentsPerBranch,
      maxTeachersPerBranch: input.maxTeachersPerBranch,
      features: input.features,
      isActive: input.isActive,
      sortOrder: input.sortOrder,
    });
  }

  /**
   * List all subscription plans.
   */
  async getAllPlans(query: PlanQueryParams): Promise<SubscriptionPlanWithCount[]> {
    const filters: PlanFilterOptions = {};
    if (query.isActive !== undefined) {
      filters.isActive = query.isActive;
    }

    return this.repo.findAll(filters);
  }

  /**
   * Retrieve a single plan by its ID.
   */
  async getPlanById(id: string): Promise<SubscriptionPlanWithCount> {
    const plan = await this.repo.findById(id);
    if (!plan) {
      throw new ErrorResponse("Subscription plan not found", statusCode.Not_Found);
    }
    return plan;
  }

  /**
   * Update an existing subscription plan.
   */
  async updatePlan(id: string, input: UpdatePlanInput): Promise<SubscriptionPlan> {
    const plan = await this.repo.findById(id);
    if (!plan) {
      throw new ErrorResponse("Subscription plan not found", statusCode.Not_Found);
    }

    if (input.name && input.name !== plan.name) {
      const existingName = await this.repo.findByName(input.name);
      if (existingName && existingName.id !== id) {
        throw new ErrorResponse(
          `Subscription plan with name '${input.name}' already exists`,
          statusCode.Conflict
        );
      }
    }

    if (input.slug && input.slug !== plan.slug) {
      const existingSlug = await this.repo.findBySlug(input.slug);
      if (existingSlug && existingSlug.id !== id) {
        throw new ErrorResponse(
          `Subscription plan with slug '${input.slug}' already exists`,
          statusCode.Conflict
        );
      }
    }

    return this.repo.update(id, input);
  }

  /**
   * Delete a subscription plan.
   * Prevents deletion if any active or trialing organizations are subscribed.
   */
  async deletePlan(id: string): Promise<{ message: string }> {
    const plan = await this.repo.findById(id);
    if (!plan) {
      throw new ErrorResponse("Subscription plan not found", statusCode.Not_Found);
    }

    const activeSubscriptions = await this.repo.countActiveSubscriptions(id);
    if (activeSubscriptions > 0) {
      throw new ErrorResponse(
        `Cannot delete subscription plan: ${activeSubscriptions} active organization(s) are currently on this plan. Deactivate the plan instead.`,
        statusCode.Conflict
      );
    }

    await this.repo.delete(id);
    return {
      message: `Subscription plan '${plan.name}' deleted successfully`,
    };
  }
}

export const planService = new PlanService();
