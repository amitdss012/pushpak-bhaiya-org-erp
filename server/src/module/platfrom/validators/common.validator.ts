import { z } from "zod";

/**
 * Common schema for validating UUID in request path parameters.
 */
export const uuidParamSchema = z.object({
  id: z.string({ message: "ID is required" }).uuid("Invalid UUID format"),
});

export type UuidParam = z.infer<typeof uuidParamSchema>;
