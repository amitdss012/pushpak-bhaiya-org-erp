import { Router } from "express";
import {
  changePassword,
  forgotPassword,
  resetPassword,
} from "../controllers/user.security.controller.js";
import { userAuthMiddleware } from "../middlewares/user.auth.middleware.js";

const userSecurityRouter: Router = Router();

/**
 * @route   POST /api/v1/user/security/change-password
 * @desc    Change password and invalidate other remote device sessions
 * @access  Protected (User)
 */
userSecurityRouter.post("/change-password", userAuthMiddleware, changePassword);

/**
 * @route   POST /api/v1/user/security/forgot-password
 * @desc    Request password reset token with 1-hour expiration
 * @access  Public
 */
userSecurityRouter.post("/forgot-password", forgotPassword);

/**
 * @route   POST /api/v1/user/security/reset-password
 * @desc    Reset password using reset token and revoke all active sessions
 * @access  Public
 */
userSecurityRouter.post("/reset-password", resetPassword);

export { userSecurityRouter };
