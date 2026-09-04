import { Router } from "express";
import { PermissionKey } from "../../../types/types.js";
import {
  assignPermissionsToRole,
  createRole,
  getRoleById,
  listPermissions,
  listRoles,
} from "../controllers/user.role.controller.js";
import {
  requirePermission,
  userAuthMiddleware,
} from "../middlewares/user.auth.middleware.js";

const userRoleRouter: Router = Router();
const userPermissionRouter: Router = Router();

// Require authentication across all role and permission routes
userRoleRouter.use(userAuthMiddleware);
userPermissionRouter.use(userAuthMiddleware);

/**
 * @route   POST /api/v1/user/roles
 * @desc    Create new role with scope enforcement and initial permissions
 * @access  Protected (CREATE_ROLE)
 */
userRoleRouter.post(
  "/",
  requirePermission(PermissionKey.CREATE_ROLE),
  createRole
);

/**
 * @route   GET /api/v1/user/roles
 * @desc    List paginated roles for caller's organization / branch
 * @access  Protected (READ_ROLE)
 */
userRoleRouter.get(
  "/",
  requirePermission(PermissionKey.READ_ROLE),
  listRoles
);

/**
 * @route   GET /api/v1/user/roles/:roleId
 * @desc    Retrieve role details with assigned permissions
 * @access  Protected (READ_ROLE)
 */
userRoleRouter.get(
  "/:roleId",
  requirePermission(PermissionKey.READ_ROLE),
  getRoleById
);

/**
 * @route   PUT /api/v1/user/roles/:roleId/permissions
 * @desc    Assign/sync atomic permissions to a role
 * @access  Protected (ASSIGN_PERMISSION)
 */
userRoleRouter.put(
  "/:roleId/permissions",
  requirePermission(PermissionKey.ASSIGN_PERMISSION),
  assignPermissionsToRole
);

/**
 * @route   GET /api/v1/user/permissions
 * @desc    List all atomic system permissions for UI selectors
 * @access  Protected (READ_PERMISSION)
 */
userPermissionRouter.get(
  "/",
  requirePermission(PermissionKey.READ_PERMISSION),
  listPermissions
);

export { userRoleRouter, userPermissionRouter };
