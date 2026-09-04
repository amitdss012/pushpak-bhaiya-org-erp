import type { Request } from "express";
import type {
  DeviceType,
  Organization,
  Branch,
  Role,
  Permission,
  Scope,
  User,
  Student,
  Teacher,
  Parent,
} from "../../../types/types.js";

/**
 * JWT Access Token Payload for authenticated User.
 */
export interface UserTokenPayload {
  id: string;
  organizationId: string;
  branchId: string | null;
  scope: Scope;
  email: string;
}

/**
 * Sanitized user entity without password hash.
 */
export type SanitizedUser = Omit<User, "passwordHash">;

/**
 * Role with its populated permissions.
 */
export interface UserRoleDetail {
  role: {
    id: string;
    name: string;
    slug: string;
    scope: Scope;
    description: string | null;
    rolePermissions: {
      permission: {
        id: string;
        key: string;
        name: string;
        module: string;
        action: string;
      };
    }[];
  };
}

/**
 * Complete sanitized user with organization, branch, roles, permissions, and persona links.
 */
export interface SanitizedUserWithDetails extends SanitizedUser {
  organization: Pick<Organization, "id" | "name" | "slug" | "logo">;
  branch: Pick<Branch, "id" | "name" | "slug" | "code"> | null;
  userRoles: UserRoleDetail[];
  student: Pick<Student, "id" | "enrollmentNo" | "applicationNo" | "admissionStatus"> | null;
  teacher: Pick<Teacher, "id" | "employeeCode" | "designation" | "status"> | null;
  parent: Pick<Parent, "id" | "occupation"> | null;
}

/**
 * Parsed client device identification from User-Agent and headers.
 */
export interface DeviceSessionInfo {
  deviceId?: string | null | undefined;
  deviceType: DeviceType;
  deviceName?: string | null | undefined;
  browser?: string | null | undefined;
  browserVersion?: string | null | undefined;
  os?: string | null | undefined;
  osVersion?: string | null | undefined;
  ipAddress?: string | null | undefined;
  location?: string | null | undefined;
  userAgent?: string | null | undefined;
}

/**
 * DTO for active device session returned to client.
 */
export interface ActiveSessionItem {
  id: string;
  deviceId: string | null;
  deviceType: DeviceType;
  deviceName: string | null;
  browser: string | null;
  browserVersion: string | null;
  os: string | null;
  osVersion: string | null;
  ipAddress: string | null;
  location: string | null;
  loginAt: Date;
  lastActiveAt: Date;
  isCurrent: boolean;
}

/**
 * Extended Express Request with authenticated user and session ID.
 */
export interface AuthenticatedUserRequest extends Request {
  user?: SanitizedUserWithDetails;
  sessionId?: string;
}

declare global {
  namespace Express {
    interface Request {
      user?: SanitizedUserWithDetails;
      sessionId?: string;
    }
  }
}
