import type { Request, Response } from "express";
import { asyncHandler } from "../../../middlewares/error.middleware.js";
import { statusCode } from "../../../types/types.js";
import { SuccessResponse } from "../../../utils/response.util.js";
import { userAuthService } from "../services/user.auth.service.js";
import {
  refreshTokenValidator,
  userLoginValidator,
} from "../validators/user.validator.js";

/**
 * @desc    Authenticate user and create device session
 * @route   POST /api/v1/user/auth/login
 * @access  Public
 */
export const userLogin = asyncHandler(async (req: Request, res: Response) => {
  const input = userLoginValidator.parse(req.body);
  const result = await userAuthService.login(input, req);

  return SuccessResponse(
    res,
    "Login successful",
    result,
    statusCode.OK
  );
});

/**
 * @desc    Rotate refresh token and issue new token pair
 * @route   POST /api/v1/user/auth/refresh-token
 * @access  Public
 */
export const userRefreshToken = asyncHandler(async (req: Request, res: Response) => {
  const input = refreshTokenValidator.parse(req.body);
  const result = await userAuthService.refreshToken(input, req);

  return SuccessResponse(
    res,
    "Token refreshed successfully",
    result,
    statusCode.OK
  );
});

/**
 * @desc    Log out current device session
 * @route   POST /api/v1/user/auth/logout
 * @access  Protected (User)
 */
export const userLogout = asyncHandler(async (req: Request, res: Response) => {
  const result = await userAuthService.logout(req.user!, req.sessionId, req);

  return SuccessResponse(res, result.message, {}, statusCode.OK);
});

/**
 * @desc    Log out all active device sessions for user
 * @route   POST /api/v1/user/auth/logout-all
 * @access  Protected (User)
 */
export const userLogoutAll = asyncHandler(async (req: Request, res: Response) => {
  const result = await userAuthService.logoutAll(req.user!, req);

  return SuccessResponse(
    res,
    result.message,
    { sessionsRevoked: result.sessionsRevoked },
    statusCode.OK
  );
});
