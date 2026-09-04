import type { Request, Response } from "express";
import { asyncHandler } from "../../../middlewares/error.middleware.js";
import { statusCode } from "../../../types/types.js";
import { SuccessResponse } from "../../../utils/response.util.js";
import { userRoleService } from "../services/user.role.service.js";
import {
  assignPermissionsToRoleValidator,
  assignRolesToUserValidator,
  createRoleValidator,
  listRolesValidator,
} from "../validators/user.validator.js";

/**
 * POST /api/v1/user/roles
 * Create a custom role with scope validation and initial permissions.
 */
export const createRole = asyncHandler(async (req: Request, res: Response) => {
  const validatedInput = createRoleValidator.parse(req.body);
  const newRole = await userRoleService.createRole(
    req.user!,
    validatedInput,
    req
  );

  return SuccessResponse(
    res,
    "Role created successfully",
    newRole,
    statusCode.Created
  );
});

/**
 * GET /api/v1/user/roles
 * List paginated roles.
 */
export const listRoles = asyncHandler(async (req: Request, res: Response) => {
  const query = listRolesValidator.parse(req.query);
  const result = await userRoleService.listRoles(req.user!, query);

  return SuccessResponse(
    res,
    "Roles retrieved successfully",
    result,
    statusCode.OK
  );
});

/**
 * GET /api/v1/user/roles/:roleId
 * Retrieve role details and assigned permissions.
 */
export const getRoleById = asyncHandler(async (req: Request, res: Response) => {
  const role = await userRoleService.getRoleById(
    req.user!,
    req.params.roleId as string
  );

  return SuccessResponse(
    res,
    "Role details retrieved",
    role,
    statusCode.OK
  );
});

/**
 * PUT /api/v1/user/roles/:roleId/permissions
 * Sync/assign atomic permissions to a role.
 */
export const assignPermissionsToRole = asyncHandler(
  async (req: Request, res: Response) => {
    const validatedInput = assignPermissionsToRoleValidator.parse(req.body);
    const updatedRole = await userRoleService.assignPermissionsToRole(
      req.user!,
      req.params.roleId as string,
      validatedInput,
      req
    );

    return SuccessResponse(
      res,
      "Permissions assigned to role successfully",
      updatedRole,
      statusCode.OK
    );
  }
);

/**
 * POST /api/v1/user/users/:userId/roles
 * Assign/sync roles to a user.
 */
export const assignRolesToUser = asyncHandler(
  async (req: Request, res: Response) => {
    const validatedInput = assignRolesToUserValidator.parse(req.body);
    const updatedUser = await userRoleService.assignRolesToUser(
      req.user!,
      req.params.userId as string,
      validatedInput,
      req
    );

    return SuccessResponse(
      res,
      "Roles assigned to user successfully",
      updatedUser,
      statusCode.OK
    );
  }
);

/**
 * GET /api/v1/user/permissions
 * List all atomic system permissions for UI selectors.
 */
export const listPermissions = asyncHandler(
  async (req: Request, res: Response) => {
    const permissions = await userRoleService.listPermissions(req.user!);

    return SuccessResponse(
      res,
      "System permissions catalog retrieved",
      permissions,
      statusCode.OK
    );
  }
);
