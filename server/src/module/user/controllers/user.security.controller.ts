import type { Request, Response } from "express";
import { asyncHandler } from "../../../middlewares/error.middleware.js";
import { statusCode } from "../../../types/types.js";
import { SuccessResponse } from "../../../utils/response.util.js";
import { userSecurityService } from "../services/user.security.service.js";
import {
  changePasswordValidator,
  forgotPasswordValidator,
  resetPasswordValidator,
} from "../validators/user.validator.js";

/**
 * @desc    Change authenticated user password
 * @route   POST /api/v1/user/security/change-password
 * @access  Protected (User)
 */
export const changePassword = asyncHandler(async (req: Request, res: Response) => {
  const input = changePasswordValidator.parse(req.body);
  const result = await userSecurityService.changePassword(
    req.user!.id,
    input,
    req.sessionId,
    req
  );

  return SuccessResponse(res, result.message, {}, statusCode.OK);
});

/**
 * @desc    Generate password reset token
 * @route   POST /api/v1/user/security/forgot-password
 * @access  Public
 */
export const forgotPassword = asyncHandler(async (req: Request, res: Response) => {
  const input = forgotPasswordValidator.parse(req.body);
  const result = await userSecurityService.forgotPassword(input, req);

  return SuccessResponse(
    res,
    result.message,
    result.resetToken ? { resetToken: result.resetToken } : {},
    statusCode.OK
  );
});

/**
 * @desc    Reset password using reset token
 * @route   POST /api/v1/user/security/reset-password
 * @access  Public
 */
export const resetPassword = asyncHandler(async (req: Request, res: Response) => {
  const input = resetPasswordValidator.parse(req.body);
  const result = await userSecurityService.resetPassword(input, req);

  return SuccessResponse(res, result.message, {}, statusCode.OK);
});
