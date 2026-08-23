import type { NextFunction, Request, Response } from "express";
import { z, type ZodTypeAny } from "zod";

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

/**
 * Middleware factory to validate request body against a Zod schema.
 */
export const validateBody =
  (schema: ZodTypeAny) =>
  async (req: Request, _res: Response, next: NextFunction): Promise<void> => {
    try {
      req.body = await schema.parseAsync(req.body);
      next();
    } catch (error) {
      next(error);
    }
  };
