import type { Request, Response } from "express";
import { asyncHandler } from "../../../middlewares/error.middleware.js";
import { statusCode } from "../../../types/types.js";
import { ErrorResponse, SuccessResponse } from "../../../utils/response.util.js";
import { platformService, type PlatformService } from "../services/platform.service.js";

export class PlatformController {
  constructor(private readonly service: PlatformService = platformService) {}

  /**
   * Controller for platform admin login.
   * POST /api/v1/platform/login
   */
  login = asyncHandler(async (req: Request, res: Response) => {
    const result = await this.service.login(req.body);
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
  getProfile = asyncHandler(async (req: Request, res: Response) => {
    const adminId = req.platformAdmin?.id;
    if (!adminId) {
      throw new ErrorResponse("Unauthorized", statusCode.Unauthorized);
    }

    const profile = await this.service.getProfile(adminId);
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
  logout = asyncHandler(async (_req: Request, res: Response) => {
    const result = await this.service.logout();
    return SuccessResponse(
      res,
      result.message || "Platform admin logged out successfully",
      {},
      statusCode.OK
    );
  });
}

export const platformController = new PlatformController();
