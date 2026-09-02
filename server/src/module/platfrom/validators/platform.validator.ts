import { z } from "zod";

/**
 * Zod validation schema for platform admin login.
 */
export const platformLoginSchema = z.object({
  email: z
    .string({ message: "Email is required" })
    .trim()
    .toLowerCase()
    .email("Please provide a valid email address"),
  password: z
    .string({ message: "Password is required" })
    .min(6, "Password must be at least 6 characters long"),
});

export type PlatformLoginInput = z.infer<typeof platformLoginSchema>;
