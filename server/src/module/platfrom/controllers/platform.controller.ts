import type { Request, Response } from "express";
import { asyncHandler } from "../../../middlewares/error.middleware.js";
import { statusCode } from "../../../types/types.js";
import { ErrorResponse, SuccessResponse } from "../../../utils/response.util.js";
import { platformService } from "../services/platform.service.js";
import { platformLoginSchema } from "../validators/platform.validator.js";

/**
 * Controller for platform admin login.
 * POST /api/v1/platform/login
 */
export const platformLogin = asyncHandler(async (req: Request, res: Response) => {
  const validatedData = await platformLoginSchema.parseAsync(req.body);
  const result = await platformService.login(validatedData);
  return SuccessResponse(
    res,
    "Platform admin login successful",
    result,
    statusCode.OK
  );
});

/**
 * Controller for fetching platform admin profile.
 * GET /api/v1/platform/profile
 */
export const getPlatformProfile = asyncHandler(async (req: Request, res: Response) => {
  const adminId = req.platformAdmin?.id;
  if (!adminId) {
    throw new ErrorResponse("Unauthorized", statusCode.Unauthorized);
  }

  const profile = await platformService.getProfile(adminId);
  return SuccessResponse(
    res,
    "Platform admin profile retrieved successfully",
    profile,
    statusCode.OK
  );
});

/**
 * Controller for platform admin logout.
 * POST /api/v1/platform/logout
 */
export const platformLogout = asyncHandler(async (_req: Request, res: Response) => {
  const result = await platformService.logout();
  return SuccessResponse(
    res,
    result.message || "Platform admin logged out successfully",
    {},
    statusCode.OK
  );
});
