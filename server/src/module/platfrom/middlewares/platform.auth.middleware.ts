import type { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import { asyncHandler } from "../../../middlewares/error.middleware.js";
import { statusCode } from "../../../types/types.js";
import { ErrorResponse } from "../../../utils/response.util.js";
import { platformRepo } from "../repos/platform.repo.js";
import type { PlatformAdminTokenPayload } from "../types/platform.types.js";

/**
 * Authentication middleware for Platform Admin routes.
 * Validates Bearer JWT token and attaches authenticated admin to `req.platformAdmin`.
 */
export const platformAuthMiddleware = asyncHandler(
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

    const secret = (process.env.JWT_SECRET || "platform_super_secret_jwt_key") as jwt.Secret;

    let decoded: PlatformAdminTokenPayload;
    try {
      decoded = jwt.verify(token, secret) as PlatformAdminTokenPayload;
    } catch (err: any) {
      if (err.name === "TokenExpiredError") {
        throw new ErrorResponse(
          "Token has expired. Please log in again.",
          statusCode.Unauthorized
        );
      }
      throw new ErrorResponse(
        "Invalid or malformed authorization token",
        statusCode.Unauthorized
      );
    }

    if (!decoded || decoded.role !== "PLATFORM_ADMIN" || !decoded.id) {
      throw new ErrorResponse(
        "Unauthorized access: Invalid platform admin token payload",
        statusCode.Unauthorized
      );
    }

    const admin = await platformRepo.findById(decoded.id);
    if (!admin) {
      throw new ErrorResponse(
        "Admin account associated with this token does not exist",
        statusCode.Unauthorized
      );
    }

    if (!admin.isActive) {
      throw new ErrorResponse(
        "Admin account is deactivated",
        statusCode.Forbidden
      );
    }

    const { passwordHash: _passwordHash, ...sanitizedAdmin } = admin;
    req.platformAdmin = sanitizedAdmin;

    next();
  }
);
