import { Router } from "express";
import { PermissionKey } from "../../../types/types.js";
import {
  createUser,
  getUserById,
  listUsers,
  updateUserStatus,
} from "../controllers/user.management.controller.js";
import { assignRolesToUser } from "../controllers/user.role.controller.js";
import {
  requirePermission,
  userAuthMiddleware,
} from "../middlewares/user.auth.middleware.js";

const userManagementRouter: Router = Router();

// Require authentication across all user management routes
userManagementRouter.use(userAuthMiddleware);

/**
 * @route   POST /api/v1/user/users
 * @desc    Create new user with credentials, scope, and initial roles
 * @access  Protected (CREATE_USER)
 */
userManagementRouter.post(
  "/",
  requirePermission(PermissionKey.CREATE_USER),
  createUser
);

/**
 * @route   GET /api/v1/user/users
 * @desc    List paginated users with branch, role, and search filters
 * @access  Protected (READ_USER)
 */
userManagementRouter.get(
  "/",
  requirePermission(PermissionKey.READ_USER),
  listUsers
);

/**
 * @route   GET /api/v1/user/users/:userId
 * @desc    Retrieve user details with assigned roles and relations
 * @access  Protected (READ_USER)
 */
userManagementRouter.get(
  "/:userId",
  requirePermission(PermissionKey.READ_USER),
  getUserById
);

/**
 * @route   PATCH /api/v1/user/users/:userId/status
 * @desc    Update user lifecycle status (ACTIVE, INACTIVE, SUSPENDED)
 * @access  Protected (SUSPEND_USER)
 */
userManagementRouter.patch(
  "/:userId/status",
  requirePermission(PermissionKey.SUSPEND_USER),
  updateUserStatus
);

/**
 * @route   POST /api/v1/user/users/:userId/roles
 * @desc    Assign/sync roles to a user
 * @access  Protected (ASSIGN_ROLE)
 */
userManagementRouter.post(
  "/:userId/roles",
  requirePermission(PermissionKey.ASSIGN_ROLE),
  assignRolesToUser
);

export { userManagementRouter };
