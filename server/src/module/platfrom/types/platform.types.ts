import type { Request } from "express";
import type { PlatformAdmin } from "../../../generated/prisma/client.js";

/**
 * Token payload embedded inside JWT for Platform Admin.
 */
export interface PlatformAdminTokenPayload {
  id: string;
  email: string;
  role: "PLATFORM_ADMIN";
}

/**
 * Platform Admin entity without sensitive password hash.
 */
export type SanitizedPlatformAdmin = Omit<PlatformAdmin, "passwordHash">;

/**
 * Extended Express Request including authenticated platform admin.
 */
export interface AuthenticatedPlatformRequest extends Request {
  platformAdmin?: SanitizedPlatformAdmin;
}

declare global {
  namespace Express {
    interface Request {
      platformAdmin?: SanitizedPlatformAdmin;
    }
  }
}
