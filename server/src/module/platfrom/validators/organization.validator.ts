import { z } from "zod";

/**
 * Schema for onboarding a new organization with an initial subscription & owner user.
 */
export const onboardOrganizationSchema = z.object({
  // Organization Info
  organization: z.object({
    name: z
      .string({ message: "Organization name is required" })
      .trim()
      .min(2, "Organization name must be at least 2 characters long")
      .max(100, "Organization name must not exceed 100 characters"),
    slug: z
      .string()
      .trim()
      .toLowerCase()
      .regex(/^[a-z0-9-]+$/, "Slug can only contain lowercase alphanumeric characters and hyphens")
      .optional(),
    email: z
      .string()
      .trim()
      .toLowerCase()
      .email("Invalid organization contact email")
      .optional()
      .nullable(),
    phone: z
      .string()
      .trim()
      .max(20, "Phone number must not exceed 20 characters")
      .optional()
      .nullable(),
    logo: z
      .string()
      .trim()
      .url("Logo must be a valid URL")
      .optional()
      .nullable(),
    address: z.string().trim().max(255).optional().nullable(),
    city: z.string().trim().max(100).optional().nullable(),
    state: z.string().trim().max(100).optional().nullable(),
    country: z.string().trim().length(2).default("IN"),
    pincode: z.string().trim().max(10).optional().nullable(),
  }),

  // Initial Subscription Details
  subscription: z.object({
    planId: z.string({ message: "Plan ID is required" }).uuid("Invalid Plan UUID"),
    billingCycle: z
      .enum(["MONTHLY", "QUARTERLY", "YEARLY"], {
        message: "Billing cycle must be MONTHLY, QUARTERLY, or YEARLY",
      })
      .default("MONTHLY"),
    status: z
      .enum(["ACTIVE", "TRIALING"], {
        message: "Initial status must be ACTIVE or TRIALING",
      })
      .default("ACTIVE"),
    trialDays: z
      .number()
      .int()
      .min(1, "Trial days must be at least 1")
      .max(365, "Trial days cannot exceed 365")
      .optional()
      .default(14),
    customPeriodEnd: z
      .string()
      .datetime({ message: "Custom period end must be a valid ISO date" })
      .optional()
      .nullable(),
  }),

  // Owner / Super Admin Account
  owner: z.object({
    firstName: z
      .string({ message: "Owner first name is required" })
      .trim()
      .min(1, "First name is required")
      .max(50, "First name must not exceed 50 characters"),
    lastName: z
      .string()
      .trim()
      .max(50, "Last name must not exceed 50 characters")
      .optional()
      .nullable(),
    email: z
      .string({ message: "Owner email is required" })
      .trim()
      .toLowerCase()
      .email("Please provide a valid email address for the owner"),
    password: z
      .string({ message: "Owner password is required" })
      .min(6, "Password must be at least 6 characters long"),
    phone: z
      .string()
      .trim()
      .max(20, "Phone number must not exceed 20 characters")
      .optional()
      .nullable(),
  }),
});

export type OnboardOrganizationInput = z.infer<typeof onboardOrganizationSchema>;

/**
 * Schema for updating organization profile and state.
 */
export const updateOrganizationSchema = z.object({
  name: z
    .string()
    .trim()
    .min(2, "Organization name must be at least 2 characters long")
    .max(100, "Organization name must not exceed 100 characters")
    .optional(),
  slug: z
    .string()
    .trim()
    .toLowerCase()
    .regex(/^[a-z0-9-]+$/, "Slug can only contain lowercase alphanumeric characters and hyphens")
    .optional(),
  email: z
    .string()
    .trim()
    .toLowerCase()
    .email("Invalid email address")
    .optional()
    .nullable(),
  phone: z
    .string()
    .trim()
    .max(20, "Phone number must not exceed 20 characters")
    .optional()
    .nullable(),
  logo: z
    .string()
    .trim()
    .url("Logo must be a valid URL")
    .optional()
    .nullable(),
  address: z.string().trim().max(255).optional().nullable(),
  city: z.string().trim().max(100).optional().nullable(),
  state: z.string().trim().max(100).optional().nullable(),
  country: z.string().trim().length(2).optional(),
  pincode: z.string().trim().max(10).optional().nullable(),
  status: z
    .enum(["ACTIVE", "INACTIVE", "SUSPENDED"], {
      message: "Status must be ACTIVE, INACTIVE, or SUSPENDED",
    })
    .optional(),
});

export type UpdateOrganizationInput = z.infer<typeof updateOrganizationSchema>;

/**
 * Schema for updating an organization's subscription plan and status.
 */
export const updateOrgSubscriptionSchema = z.object({
  planId: z.string().uuid("Invalid Plan UUID").optional(),
  billingCycle: z
    .enum(["MONTHLY", "QUARTERLY", "YEARLY"], {
      message: "Billing cycle must be MONTHLY, QUARTERLY, or YEARLY",
    })
    .optional(),
  status: z
    .enum(["ACTIVE", "PAST_DUE", "CANCELLED", "EXPIRED", "TRIALING"], {
      message: "Invalid subscription status",
    })
    .optional(),
  currentPeriodEnd: z
    .string()
    .datetime({ message: "Invalid date format for currentPeriodEnd" })
    .optional(),
  trialEndsAt: z
    .string()
    .datetime({ message: "Invalid date format for trialEndsAt" })
    .optional()
    .nullable(),
});

export type UpdateOrgSubscriptionInput = z.infer<typeof updateOrgSubscriptionSchema>;

/**
 * Schema for query params when listing organizations.
 */
export const orgQuerySchema = z.object({
  page: z
    .string()
    .optional()
    .transform((val) => (val ? Math.max(1, parseInt(val, 10) || 1) : 1)),
  limit: z
    .string()
    .optional()
    .transform((val) => (val ? Math.min(100, Math.max(1, parseInt(val, 10) || 10)) : 10)),
  search: z.string().trim().optional(),
  status: z.enum(["ACTIVE", "INACTIVE", "SUSPENDED"]).optional(),
  planId: z.string().uuid("Invalid Plan UUID").optional(),
  sortBy: z.enum(["createdAt", "name", "status"]).optional().default("createdAt"),
  sortOrder: z.enum(["asc", "desc"]).optional().default("desc"),
});

export type OrgQueryParams = z.infer<typeof orgQuerySchema>;
