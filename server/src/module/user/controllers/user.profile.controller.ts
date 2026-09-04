import type { Request, Response } from "express";
import { asyncHandler } from "../../../middlewares/error.middleware.js";
import { statusCode } from "../../../types/types.js";
import { SuccessResponse } from "../../../utils/response.util.js";
import { userProfileService } from "../services/user.profile.service.js";
import {
  updateAvatarValidator,
  updateProfileValidator,
} from "../validators/user.validator.js";

/**
 * @desc    Get authenticated user profile with roles, permissions, and persona
 * @route   GET /api/v1/user/profile
 * @access  Protected (User)
 */
export const getUserProfile = asyncHandler(async (req: Request, res: Response) => {
  const profile = await userProfileService.getProfile(req.user!.id);

  return SuccessResponse(
    res,
    "Profile retrieved successfully",
    profile,
    statusCode.OK
  );
});

/**
 * @desc    Update authenticated user's personal details
 * @route   PATCH /api/v1/user/profile
 * @access  Protected (User)
 */
export const updateUserProfile = asyncHandler(async (req: Request, res: Response) => {
  const input = updateProfileValidator.parse(req.body);
  const updated = await userProfileService.updateProfile(req.user!.id, input, req);

  return SuccessResponse(
    res,
    "Profile updated successfully",
    updated,
    statusCode.OK
  );
});

/**
 * @desc    Update authenticated user's avatar image URL
 * @route   PATCH /api/v1/user/avatar
 * @access  Protected (User)
 */
export const updateUserAvatar = asyncHandler(async (req: Request, res: Response) => {
  const input = updateAvatarValidator.parse(req.body);
  const updated = await userProfileService.updateAvatar(req.user!.id, input, req);

  return SuccessResponse(
    res,
    "Avatar updated successfully",
    updated,
    statusCode.OK
  );
});
