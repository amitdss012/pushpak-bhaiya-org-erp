import { z } from "zod";

/**
 * Validator for creating a master Academic Session and mapping to branches.
 */
export const createSessionValidator = z
  .object({
    name: z
      .string({ message: "Session name is required" })
      .min(3, { message: "Session name must be at least 3 characters" })
      .max(100, { message: "Session name cannot exceed 100 characters" })
      .trim(),
    code: z
      .string()
      .max(50, { message: "Session code cannot exceed 50 characters" })
      .trim()
      .optional()
      .nullable(),
    startYear: z.coerce
      .number({ message: "Start year is required" })
      .int({ message: "Start year must be an integer" })
      .min(2000, { message: "Start year must be 2000 or later" })
      .max(2100, { message: "Start year cannot exceed 2100" }),
    endYear: z.coerce
      .number({ message: "End year is required" })
      .int({ message: "End year must be an integer" })
      .min(2000, { message: "End year must be 2000 or later" })
      .max(2100, { message: "End year cannot exceed 2100" }),
    startDate: z.coerce.date({
      message: "Start date is required",
    }),
    endDate: z.coerce.date({
      message: "End date is required",
    }),
    description: z
      .string()
      .max(500, { message: "Description cannot exceed 500 characters" })
      .trim()
      .optional()
      .nullable(),
    branchIds: z
      .array(z.string().uuid({ message: "Invalid branch ID" }))
      .optional()
      .default([]),
    isCurrentForBranches: z.boolean().optional().default(false),
  })
  .refine((data) => data.endYear >= data.startYear, {
    message: "End year must be greater than or equal to start year",
    path: ["endYear"],
  })
  .refine((data) => data.endDate > data.startDate, {
    message: "End date must be after start date",
    path: ["endDate"],
  });

export type CreateSessionInput = z.infer<typeof createSessionValidator>;

/**
 * Validator for updating master Academic Session metadata.
 */
export const updateSessionValidator = z
  .object({
    name: z.string().min(3).max(100).trim().optional(),
    code: z.string().max(50).trim().optional().nullable(),
    startYear: z.coerce.number().int().min(2000).max(2100).optional(),
    endYear: z.coerce.number().int().min(2000).max(2100).optional(),
    startDate: z.coerce.date().optional(),
    endDate: z.coerce.date().optional(),
    description: z.string().max(500).trim().optional().nullable(),
  })
  .refine(
    (data) => {
      if (data.startYear && data.endYear) {
        return data.endYear >= data.startYear;
      }
      return true;
    },
    {
      message: "End year must be greater than or equal to start year",
      path: ["endYear"],
    }
  )
  .refine(
    (data) => {
      if (data.startDate && data.endDate) {
        return data.endDate > data.startDate;
      }
      return true;
    },
    {
      message: "End date must be after start date",
      path: ["endDate"],
    }
  );

export type UpdateSessionInput = z.infer<typeof updateSessionValidator>;

/**
 * Validator for mapping branches to an Academic Session.
 */
export const mapBranchesValidator = z.object({
  branchIds: z
    .array(z.string().uuid({ message: "Invalid branch ID" }))
    .min(1, { message: "At least one branch ID must be provided" }),
  isCurrent: z.boolean().optional().default(false),
});

export type MapBranchesInput = z.infer<typeof mapBranchesValidator>;

/**
 * Validator for setting a branch's active/current session.
 */
export const setBranchCurrentSessionValidator = z.object({
  branchId: z.string().uuid({ message: "Invalid branch ID" }),
  branchAcademicSessionId: z.string().uuid({
    message: "Invalid branch academic session ID",
  }),
});

export type SetBranchCurrentSessionInput = z.infer<
  typeof setBranchCurrentSessionValidator
>;

/**
 * Validator for listing sessions with filters.
 */
export const listSessionsValidator = z.object({
  page: z.coerce.number().int().positive().default(1),
  limit: z.coerce.number().int().positive().max(100).default(20),
  search: z.string().trim().optional(),
  branchId: z.string().uuid().optional(),
});

export type ListSessionsInput = z.infer<typeof listSessionsValidator>;
