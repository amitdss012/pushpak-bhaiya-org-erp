import type { Request, Response } from "express";
import { asyncHandler } from "../../../middlewares/error.middleware.js";
import { statusCode } from "../../../types/types.js";
import { SuccessResponse } from "../../../utils/response.util.js";
import { userManagementService } from "../services/user.management.service.js";
import {
  createUserValidator,
  listUsersValidator,
  updateUserStatusValidator,
} from "../validators/user.validator.js";

/**
 * POST /api/v1/user/users
 * Create a new user with scope-based multi-tenant enforcement.
 */
export const createUser = asyncHandler(async (req: Request, res: Response) => {
  const validatedInput = createUserValidator.parse(req.body);
  const newUser = await userManagementService.createUser(
    req.user!,
    validatedInput,
    req
  );

  return SuccessResponse(
    res,
    "User created successfully",
    newUser,
    statusCode.Created
  );
});

/**
 * GET /api/v1/user/users
 * List paginated users with branch, role, and search filters.
 */
export const listUsers = asyncHandler(async (req: Request, res: Response) => {
  const query = listUsersValidator.parse(req.query);
  const result = await userManagementService.listUsers(req.user!, query);

  return SuccessResponse(
    res,
    "Users retrieved successfully",
    result,
    statusCode.OK
  );
});

/**
 * GET /api/v1/user/users/:userId
 * Retrieve single user details by ID.
 */
export const getUserById = asyncHandler(async (req: Request, res: Response) => {
  const user = await userManagementService.getUserById(
    req.user!,
    req.params.userId as string
  );

  return SuccessResponse(
    res,
    "User details retrieved",
    user,
    statusCode.OK
  );
});

/**
 * PATCH /api/v1/user/users/:userId/status
 * Update user lifecycle status (ACTIVE, INACTIVE, SUSPENDED).
 */
export const updateUserStatus = asyncHandler(
  async (req: Request, res: Response) => {
    const validatedInput = updateUserStatusValidator.parse(req.body);
    const updatedUser = await userManagementService.updateUserStatus(
      req.user!,
      req.params.userId as string,
      validatedInput,
      req
    );

    return SuccessResponse(
      res,
      `User status updated to ${validatedInput.status}`,
      updatedUser,
      statusCode.OK
    );
  }
);
