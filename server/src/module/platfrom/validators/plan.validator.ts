import { z } from "zod";

/**
 * Zod schema for creating a new subscription plan.
 */
export const createPlanSchema = z.object({
  name: z
    .string({ message: "Plan name is required" })
    .trim()
    .min(2, "Plan name must be at least 2 characters long")
    .max(50, "Plan name must not exceed 50 characters"),
  slug: z
    .string()
    .trim()
    .toLowerCase()
    .regex(/^[a-z0-9-]+$/, "Slug can only contain lowercase alphanumeric characters and hyphens")
    .optional(),
  description: z
    .string()
    .trim()
    .max(500, "Description must not exceed 500 characters")
    .optional()
    .nullable(),
  priceMonthly: z
    .number({ message: "Monthly price is required" })
    .min(0, "Monthly price must be non-negative"),
  priceYearly: z
    .number({ message: "Yearly price is required" })
    .min(0, "Yearly price must be non-negative"),
  currency: z
    .string()
    .trim()
    .toUpperCase()
    .length(3, "Currency must be a 3-letter ISO code")
    .default("INR"),
  maxBranches: z
    .number({ message: "Max branches is required" })
    .int("Max branches must be an integer")
    .min(1, "Plan must allow at least 1 branch"),
  maxStudentsPerBranch: z
    .number({ message: "Max students per branch is required" })
    .int("Max students per branch must be an integer")
    .min(1, "Max students per branch must be at least 1"),
  maxTeachersPerBranch: z
    .number({ message: "Max teachers per branch is required" })
    .int("Max teachers per branch must be an integer")
    .min(1, "Max teachers per branch must be at least 1"),
  features: z
    .record(z.string(), z.any())
    .optional()
    .default({}),
  isActive: z
    .boolean()
    .optional()
    .default(true),
  sortOrder: z
    .number()
    .int("Sort order must be an integer")
    .optional()
    .default(0),
});

export type CreatePlanInput = z.infer<typeof createPlanSchema>;

/**
 * Zod schema for updating an existing subscription plan.
 */
export const updatePlanSchema = z.object({
  name: z
    .string()
    .trim()
    .min(2, "Plan name must be at least 2 characters long")
    .max(50, "Plan name must not exceed 50 characters")
    .optional(),
  slug: z
    .string()
    .trim()
    .toLowerCase()
    .regex(/^[a-z0-9-]+$/, "Slug can only contain lowercase alphanumeric characters and hyphens")
    .optional(),
  description: z
    .string()
    .trim()
    .max(500, "Description must not exceed 500 characters")
    .optional()
    .nullable(),
  priceMonthly: z
    .number()
    .min(0, "Monthly price must be non-negative")
    .optional(),
  priceYearly: z
    .number()
    .min(0, "Yearly price must be non-negative")
    .optional(),
  currency: z
    .string()
    .trim()
    .toUpperCase()
    .length(3, "Currency must be a 3-letter ISO code")
    .optional(),
  maxBranches: z
    .number()
    .int("Max branches must be an integer")
    .min(1, "Plan must allow at least 1 branch")
    .optional(),
  maxStudentsPerBranch: z
    .number()
    .int("Max students per branch must be an integer")
    .min(1, "Max students per branch must be at least 1")
    .optional(),
  maxTeachersPerBranch: z
    .number()
    .int("Max teachers per branch must be an integer")
    .min(1, "Max teachers per branch must be at least 1")
    .optional(),
  features: z
    .record(z.string(), z.any())
    .optional(),
  isActive: z
    .boolean()
    .optional(),
  sortOrder: z
    .number()
    .int("Sort order must be an integer")
    .optional(),
});

export type UpdatePlanInput = z.infer<typeof updatePlanSchema>;

/**
 * Query schema for listing plans.
 */
export const planQuerySchema = z.object({
  isActive: z
    .enum(["true", "false"])
    .transform((val) => val === "true")
    .optional(),
});

export type PlanQueryParams = z.infer<typeof planQuerySchema>;
