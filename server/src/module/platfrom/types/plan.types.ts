import type { SubscriptionPlan } from "../../../generated/prisma/client.js";

/**
 * Filter options for querying subscription plans.
 */
export interface PlanFilterOptions {
  isActive?: boolean;
}

/**
 * Plan summary response with subscriber counts.
 */
export type SubscriptionPlanWithCount = SubscriptionPlan & {
  _count?: {
    subscriptions: number;
  };
};
