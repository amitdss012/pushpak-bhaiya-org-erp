import { Router } from "express";
import {
  userLogin,
  userLogout,
  userLogoutAll,
  userRefreshToken,
} from "../controllers/user.auth.controller.js";
import { userAuthMiddleware } from "../middlewares/user.auth.middleware.js";

const userAuthRouter: Router = Router();

/**
 * @route   POST /api/v1/user/auth/login
 * @desc    Authenticate user with credentials and register active device session
 * @access  Public
 */
userAuthRouter.post("/login", userLogin);

/**
 * @route   POST /api/v1/user/auth/refresh-token
 * @desc    Rotate refresh token, issue new token pair, and detect replay attack
 * @access  Public
 */
userAuthRouter.post("/refresh-token", userRefreshToken);

/**
 * @route   POST /api/v1/user/auth/logout
 * @desc    Terminate current device session
 * @access  Protected (User)
 */
userAuthRouter.post("/logout", userAuthMiddleware, userLogout);

/**
 * @route   POST /api/v1/user/auth/logout-all
 * @desc    Terminate all active device sessions for authenticated user
 * @access  Protected (User)
 */
userAuthRouter.post("/logout-all", userAuthMiddleware, userLogoutAll);

export { userAuthRouter };
