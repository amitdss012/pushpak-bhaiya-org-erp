import type { NextFunction, Request, Response } from "express";
import { asyncHandler } from "../../../middlewares/error.middleware.js";
import { statusCode, type Scope, type PermissionKey } from "../../../types/types.js";
import { verifyToken } from "../../../utils/jwt.js";
import { ErrorResponse } from "../../../utils/response.util.js";
import { userRepo } from "../repos/user.repo.js";
import type { SanitizedUserWithDetails, UserTokenPayload } from "../types/user.types.js";

/**
 * Authentication middleware for Organization and Branch Users.
 * Validates JWT access token, ensures account is ACTIVE, and populates `req.user`.
 */
export const userAuthMiddleware = asyncHandler(
  async (req: Request, _res: Response, next: NextFunction) => {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      throw new ErrorResponse(
        "Authorization token is required (format: 'Bearer <token>')",
        statusCode.Unauthorized
      );
    }

    const token = authHeader.split(" ")[1]?.trim();
    if (!token) {
      throw new ErrorResponse(
        "Authorization token missing",
        statusCode.Unauthorized
      );
    }

    let decoded: UserTokenPayload;
    try {
      decoded = verifyToken<UserTokenPayload>(token);
    } catch (err: any) {
      if (err.name === "TokenExpiredError") {
        throw new ErrorResponse(
          "Token has expired. Please refresh your session.",
          statusCode.Unauthorized
        );
      }
      throw new ErrorResponse(
        "Invalid or malformed authorization token",
        statusCode.Unauthorized
      );
    }

    if (!decoded || !decoded.id) {
      throw new ErrorResponse(
        "Unauthorized access: Invalid token payload",
        statusCode.Unauthorized
      );
    }

    const user = await userRepo.findByIdWithDetails(decoded.id);
    if (!user) {
      throw new ErrorResponse(
        "User account associated with this token does not exist",
        statusCode.Unauthorized
      );
    }

    if (user.status !== "ACTIVE") {
      throw new ErrorResponse(
        `Your account status is ${user.status}. Please contact your administrator.`,
        statusCode.Forbidden
      );
    }

    // Strip sensitive fields
    const { passwordHash: _passwordHash, ...sanitizedUser } = user;
    req.user = sanitizedUser as unknown as SanitizedUserWithDetails;

    // Attach session ID from headers if provided
    const sessionIdHeader = req.headers["x-session-id"] as string | undefined;
    if (sessionIdHeader) {
      req.sessionId = sessionIdHeader;
    }

    next();
  }
);

/**
 * Middleware to restrict access based on user Scope (ORGANIZATION or BRANCH).
 */
export const requireScope = (...allowedScopes: Scope[]) => {
  return (req: Request, _res: Response, next: NextFunction) => {
    if (!req.user) {
      throw new ErrorResponse("Authentication required", statusCode.Unauthorized);
    }

    if (!allowedScopes.includes(req.user.scope)) {
      throw new ErrorResponse(
        `Access denied: Scope '${req.user.scope}' is not authorized for this resource`,
        statusCode.Forbidden
      );
    }

    next();
  };
};

/**
 * Middleware to restrict access based on atomic permission key.
 */
export const requirePermission = (permissionKey: PermissionKey | string) => {
  return (req: Request, _res: Response, next: NextFunction) => {
    if (!req.user) {
      throw new ErrorResponse("Authentication required", statusCode.Unauthorized);
    }

    const hasPermission = req.user.userRoles?.some((ur) =>
      ur.role?.rolePermissions?.some((rp) => rp.permission?.key === permissionKey)
    );

    if (!hasPermission) {
      throw new ErrorResponse(
        `Access denied: Missing required permission '${permissionKey}'`,
        statusCode.Forbidden
      );
    }

    next();
  };
};

/**
 * Middleware to restrict access based on role slug.
 */
export const requireRole = (...roleSlugs: string[]) => {
  return (req: Request, _res: Response, next: NextFunction) => {
    if (!req.user) {
      throw new ErrorResponse("Authentication required", statusCode.Unauthorized);
    }

    const hasRole = req.user.userRoles?.some((ur) =>
      roleSlugs.includes(ur.role?.slug)
    );

    if (!hasRole) {
      throw new ErrorResponse(
        `Access denied: Requires one of roles: [${roleSlugs.join(", ")}]`,
        statusCode.Forbidden
      );
    }

    next();
  };
};
