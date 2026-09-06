import { z } from "zod";

/**
 * Validator for User Login
 */
export const userLoginValidator = z.object({
  email: z
    .string({ message: "Email is required" })
    .trim()
    .toLowerCase()
    .email({ message: "Invalid email format" }),
  password: z
    .string({ message: "Password is required" })
    .min(6, { message: "Password must be at least 6 characters" }),
  organizationId: z
    .string()
    .uuid({ message: "Invalid organization ID format" })
    .optional(),
  deviceId: z.string().trim().optional(),
  deviceType: z
    .enum(["DESKTOP", "MOBILE", "TABLET", "UNKNOWN"])
    .optional()
    .default("UNKNOWN"),
  deviceName: z.string().trim().max(100).optional(),
});

export type UserLoginInput = z.infer<typeof userLoginValidator>;

/**
 * Validator for Refresh Token
 */
export const refreshTokenValidator = z.object({
  refreshToken: z
    .string({ message: "Refresh token is required" })
    .trim()
    .min(1, { message: "Refresh token cannot be empty" }),
});

export type RefreshTokenInput = z.infer<typeof refreshTokenValidator>;

/**
 * Validator for Updating User Profile
 */
export const updateProfileValidator = z.object({
  firstName: z
    .string()
    .trim()
    .min(1, { message: "First name cannot be empty" })
    .max(50, { message: "First name cannot exceed 50 characters" })
    .optional(),
  lastName: z
    .string()
    .trim()
    .max(50, { message: "Last name cannot exceed 50 characters" })
    .nullable()
    .optional(),
  phone: z
    .string()
    .trim()
    .max(20, { message: "Phone number cannot exceed 20 characters" })
    .nullable()
    .optional(),
});

export type UpdateProfileInput = z.infer<typeof updateProfileValidator>;

/**
 * Validator for Updating User Avatar
 */
export const updateAvatarValidator = z.object({
  avatar: z
    .string({ message: "Avatar URL is required" })
    .trim()
    .url({ message: "Avatar must be a valid URL" }),
});

export type UpdateAvatarInput = z.infer<typeof updateAvatarValidator>;

/**
 * Validator for Changing Password
 */
export const changePasswordValidator = z.object({
  currentPassword: z
    .string({ message: "Current password is required" })
    .min(1, { message: "Current password cannot be empty" }),
  newPassword: z
    .string({ message: "New password is required" })
    .min(8, { message: "New password must be at least 8 characters" })
    .max(100, { message: "New password cannot exceed 100 characters" }),
});

export type ChangePasswordInput = z.infer<typeof changePasswordValidator>;

/**
 * Validator for Forgot Password Request
 */
export const forgotPasswordValidator = z.object({
  email: z
    .string({ message: "Email is required" })
    .trim()
    .toLowerCase()
    .email({ message: "Invalid email format" }),
  organizationId: z
    .string()
    .uuid({ message: "Invalid organization ID format" })
    .optional(),
});

export type ForgotPasswordInput = z.infer<typeof forgotPasswordValidator>;

/**
 * Validator for Password Reset Confirmation
 */
export const resetPasswordValidator = z.object({
  token: z
    .string({ message: "Reset token is required" })
    .trim()
    .min(1, { message: "Reset token cannot be empty" }),
  newPassword: z
    .string({ message: "New password is required" })
    .min(8, { message: "New password must be at least 8 characters" })
    .max(100, { message: "New password cannot exceed 100 characters" }),
});

export type ResetPasswordInput = z.infer<typeof resetPasswordValidator>;

/**
 * Validator for Paginated Queries
 */
export const paginationQueryValidator = z.object({
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
});

export type PaginationQueryInput = z.infer<typeof paginationQueryValidator>;

/**
 * Validator for Creating a User (Organization or Branch Scoped)
 */
export const createUserValidator = z.object({
  email: z
    .string({ message: "Email is required" })
    .trim()
    .toLowerCase()
    .email({ message: "Invalid email format" }),
  password: z
    .string({ message: "Password is required" })
    .min(6, { message: "Password must be at least 6 characters" })
    .max(100, { message: "Password cannot exceed 100 characters" }),
  firstName: z
    .string({ message: "First name is required" })
    .trim()
    .min(1, { message: "First name cannot be empty" })
    .max(50, { message: "First name cannot exceed 50 characters" }),
  lastName: z
    .string()
    .trim()
    .max(50, { message: "Last name cannot exceed 50 characters" })
    .optional(),
  phone: z
    .string()
    .trim()
    .max(20, { message: "Phone number cannot exceed 20 characters" })
    .optional(),
  scope: z.enum(["ORGANIZATION", "BRANCH"]).optional(),
  branchId: z
    .string()
    .uuid({ message: "Invalid branch ID format" })
    .nullable()
    .optional(),
  roleIds: z
    .array(z.string().uuid({ message: "Invalid role ID format" }))
    .optional(),
});

export type CreateUserInput = z.infer<typeof createUserValidator>;

/**
 * Validator for Listing Paginated Users
 */
export const listUsersValidator = z.object({
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  search: z.string().trim().optional(),
  scope: z.enum(["ORGANIZATION", "BRANCH"]).optional(),
  branchId: z.string().uuid({ message: "Invalid branch ID format" }).optional(),
  status: z.enum(["ACTIVE", "INACTIVE", "SUSPENDED", "INVITED"]).optional(),
  roleId: z.string().uuid({ message: "Invalid role ID format" }).optional(),
});

export type ListUsersInput = z.infer<typeof listUsersValidator>;

/**
 * Validator for Updating User Status (Activate, Suspend, Deactivate)
 */
export const updateUserStatusValidator = z.object({
  status: z.enum(["ACTIVE", "INACTIVE", "SUSPENDED", "INVITED"], {
    message: "Invalid status value",
  }),
});

export type UpdateUserStatusInput = z.infer<typeof updateUserStatusValidator>;

/**
 * Validator for Creating a Role
 */
export const createRoleValidator = z
  .object({
    name: z
      .string({ message: "Role name is required" })
      .trim()
      .min(2, { message: "Role name must be at least 2 characters" })
      .max(50, { message: "Role name cannot exceed 50 characters" }),
    description: z
      .string()
      .trim()
      .max(255, { message: "Description cannot exceed 255 characters" })
      .optional(),
    scope: z.enum(["ORGANIZATION", "BRANCH"]).optional(),
    branchId: z
      .string()
      .uuid({ message: "Invalid branch ID format" })
      .nullable()
      .optional(),
    permissionKeys: z
      .array(z.string().trim().min(1, { message: "Permission key cannot be empty" }))
      .optional(),
    permissions: z
      .array(z.string().trim().min(1, { message: "Permission key cannot be empty" }))
      .optional(),
  })
  .transform((data) => ({
    ...data,
    permissionKeys: data.permissionKeys ?? data.permissions,
  }));

export type CreateRoleInput = z.infer<typeof createRoleValidator>;

/**
 * Validator for Listing Roles
 */
export const listRolesValidator = z.object({
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(50),
  search: z.string().trim().optional(),
  scope: z.enum(["ORGANIZATION", "BRANCH"]).optional(),
  branchId: z.string().uuid({ message: "Invalid branch ID format" }).optional(),
});

export type ListRolesInput = z.infer<typeof listRolesValidator>;

/**
 * Validator for Assigning/Syncing Permissions to a Role
 */
export const assignPermissionsToRoleValidator = z
  .object({
    permissionKeys: z
      .array(
        z.string().trim().min(1, { message: "Permission key cannot be empty" })
      )
      .optional(),
    permissions: z
      .array(
        z.string().trim().min(1, { message: "Permission key cannot be empty" })
      )
      .optional(),
  })
  .superRefine((data, ctx) => {
    const keys = data.permissionKeys ?? data.permissions;
    if (!keys || !Array.isArray(keys)) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: "permissionKeys array is required",
        path: ["permissionKeys"],
      });
    }
  })
  .transform((data) => ({
    permissionKeys: (data.permissionKeys ?? data.permissions) as string[],
  }));

export type AssignPermissionsToRoleInput = z.infer<
  typeof assignPermissionsToRoleValidator
>;

/**
 * Validator for Assigning Roles to a User
 */
export const assignRolesToUserValidator = z.object({
  roleIds: z.array(z.string().uuid({ message: "Invalid role ID format" }), {
    message: "roleIds array is required",
  }),
});

export type AssignRolesToUserInput = z.infer<typeof assignRolesToUserValidator>;
