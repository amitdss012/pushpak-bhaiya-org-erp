import type {
  BillingCycle,
  OrgStatus,
  SubscriptionPlan,
  SubscriptionStatus,
} from "../../../generated/prisma/client.js";

/**
 * Filter and pagination query parameters for listing organizations.
 */
export interface OrganizationQueryParams {
  page?: number;
  limit?: number;
  search?: string;
  status?: OrgStatus;
  planId?: string;
  sortBy?: "createdAt" | "name" | "status";
  sortOrder?: "asc" | "desc";
}

/**
 * Paginated response wrapper for organizations.
 */
export interface PaginatedResult<T> {
  data: T[];
  pagination: {
    total: number;
    page: number;
    limit: number;
    totalPages: number;
    hasNextPage: boolean;
    hasPrevPage: boolean;
  };
}

/**
 * Sanitized user response for organization owner.
 */
export interface SanitizedOrgOwner {
  id: string;
  firstName: string;
  lastName: string | null;
  email: string;
  phone: string | null;
  status: string;
  createdAt: Date;
}

/**
 * Subscription details embedded in organization responses.
 */
export interface OrganizationActiveSubscription {
  id: string;
  planId: string;
  status: SubscriptionStatus;
  billingCycle: BillingCycle;
  currentPeriodStart: Date;
  currentPeriodEnd: Date;
  trialEndsAt: Date | null;
  plan: Pick<
    SubscriptionPlan,
    | "id"
    | "name"
    | "slug"
    | "priceMonthly"
    | "priceYearly"
    | "currency"
    | "maxBranches"
    | "maxStudentsPerBranch"
    | "maxTeachersPerBranch"
    | "features"
  >;
}

/**
 * Organization item in list view.
 */
export interface OrganizationListItem {
  id: string;
  name: string;
  slug: string;
  email: string | null;
  phone: string | null;
  logo: string | null;
  status: OrgStatus;
  createdAt: Date;
  updatedAt: Date;
  activeSubscription: OrganizationActiveSubscription | null;
  owner: SanitizedOrgOwner | null;
  _count: {
    branches: number;
    users: number;
  };
}

/**
 * Comprehensive Organization detail entity.
 */
export interface OrganizationDetailResponse {
  id: string;
  name: string;
  slug: string;
  email: string | null;
  phone: string | null;
  logo: string | null;
  address: string | null;
  city: string | null;
  state: string | null;
  country: string | null;
  pincode: string | null;
  status: OrgStatus;
  createdAt: Date;
  updatedAt: Date;
  activeSubscription: OrganizationActiveSubscription | null;
  subscriptions: Array<{
    id: string;
    status: SubscriptionStatus;
    billingCycle: BillingCycle;
    currentPeriodStart: Date;
    currentPeriodEnd: Date;
    trialEndsAt: Date | null;
    cancelledAt: Date | null;
    plan: {
      id: string;
      name: string;
      slug: string;
    };
  }>;
  owner: SanitizedOrgOwner | null;
  stats: {
    branchesCount: number;
    usersCount: number;
  };
}
