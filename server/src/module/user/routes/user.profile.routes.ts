import { Router } from "express";
import {
  getUserProfile,
  updateUserAvatar,
  updateUserProfile,
} from "../controllers/user.profile.controller.js";
import { userAuthMiddleware } from "../middlewares/user.auth.middleware.js";

const userProfileRouter: Router = Router();

// All profile endpoints require authenticated user
userProfileRouter.use(userAuthMiddleware);

/**
 * @route   GET /api/v1/user/profile
 * @desc    Retrieve authenticated user profile with roles, permissions, and persona
 * @access  Protected (User)
 */
userProfileRouter.get("/", getUserProfile);

/**
 * @route   PATCH /api/v1/user/profile
 * @desc    Update authenticated user's personal details (firstName, lastName, phone)
 * @access  Protected (User)
 */
userProfileRouter.patch("/", updateUserProfile);

/**
 * @route   PATCH /api/v1/user/profile/avatar
 * @desc    Update authenticated user's avatar image URL
 * @access  Protected (User)
 */
userProfileRouter.patch("/avatar", updateUserAvatar);

export { userProfileRouter };
