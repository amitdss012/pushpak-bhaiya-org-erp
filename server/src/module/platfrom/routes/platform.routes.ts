import { Router } from "express";
import { platformController } from "../controllers/platform.controller.js";
import { platformAuthMiddleware } from "../middlewares/platform.auth.middleware.js";
import {
  platformLoginSchema,
  validateBody,
} from "../validators/platform.validator.js";

const platformRouter: Router = Router();

/**
 * @route   POST /api/v1/platform/login
 * @desc    Authenticate platform admin and issue JWT token
 * @access  Public
 */
platformRouter.post(
  "/login",
  validateBody(platformLoginSchema),
  platformController.login
);

/**
 * @route   GET /api/v1/platform/profile
 * @desc    Retrieve authenticated platform admin's profile
 * @access  Protected (Platform Admin)
 */
platformRouter.get(
  "/profile",
  platformAuthMiddleware,
  platformController.getProfile
);

/**
 * @route   POST /api/v1/platform/logout
 * @desc    Logout platform admin session
 * @access  Protected (Platform Admin)
 */
platformRouter.post(
  "/logout",
  platformAuthMiddleware,
  platformController.logout
);

export { platformRouter };
export default platformRouter;
