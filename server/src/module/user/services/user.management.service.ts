import type { Request } from "express";
import { statusCode, type UserStatus } from "../../../types/types.js";
import { hashPassword } from "../../../utils/password.js";
import { ErrorResponse } from "../../../utils/response.util.js";
import { auditLogRepo, type AuditLogRepo } from "../repos/audit-log.repo.js";
import { roleRepo, type RoleRepo } from "../repos/role.repo.js";
import { userRepo, type UserRepo } from "../repos/user.repo.js";
import type { SanitizedUserWithDetails } from "../types/user.types.js";
import type {
  CreateUserInput,
  ListUsersInput,
  UpdateUserStatusInput,
} from "../validators/user.validator.js";
import { userScopeService, type UserScopeService } from "./user.scope.service.js";

export class UserManagementService {
  constructor(
    private readonly users: UserRepo = userRepo,
    private readonly roles: RoleRepo = roleRepo,
    private readonly auditLogs: AuditLogRepo = auditLogRepo,
    private readonly scope: UserScopeService = userScopeService
  ) {}

  /**
   * Helper to format User model with nested roles and relations.
   */
  private formatUserDetails(user: any): SanitizedUserWithDetails {
    if (!user) {
      throw new ErrorResponse("User not found", statusCode.Not_Found);
    }
    const { passwordHash: _passwordHash, ...sanitized } = user;
    return sanitized as unknown as SanitizedUserWithDetails;
  }

  /**
   * Create a new user with scope-based multi-tenant enforcement.
   * - Organization user can create users for the organization or any branch within their org.
   * - Branch user can only create users for their assigned branch.
   */
  async createUser(
    caller: SanitizedUserWithDetails,
    input: CreateUserInput,
    req: Request
  ): Promise<SanitizedUserWithDetails> {
    // 1. Enforce Multi-Tenant Scope Boundaries via Scope Service
    const { scope: targetScope, branchId: targetBranchId } =
      await this.scope.resolveTargetScopeAndBranch(caller, {
        scope: input.scope,
        branchId: input.branchId,
      });

    // 2. Validate email uniqueness within this tenant
    const existing = await this.users.findByEmail(
      input.email,
      caller.organizationId
    );
    if (existing) {
      throw new ErrorResponse(
        `A user with email '${input.email}' already exists in this organization`,
        statusCode.Conflict
      );
    }

    // 3. Validate optional role assignments and scope compatibility
    if (input.roleIds && input.roleIds.length > 0) {
      const roles = await this.roles.findManyByIds(
        input.roleIds,
        caller.organizationId
      );

      if (roles.length !== input.roleIds.length) {
        throw new ErrorResponse(
          "One or more specified role IDs do not exist in your organization",
          statusCode.Bad_Request
        );
      }

      this.scope.assertRoleScopeCompatibility(
        { scope: targetScope, branchId: targetBranchId },
        roles,
        caller
      );
    }

    // 4. Securely hash password using centralized utility
    const passwordHash = await hashPassword(input.password);

    // 5. Persist new user
    const createdUser = await this.users.create({
      organizationId: caller.organizationId,
      branchId: targetBranchId,
      scope: targetScope,
      email: input.email,
      passwordHash,
      firstName: input.firstName,
      lastName: input.lastName ?? null,
      phone: input.phone ?? null,
      status: "ACTIVE",
      roleIds: input.roleIds,
    });

    // 6. Record immutable audit log
    await this.auditLogs.create({
      organizationId: caller.organizationId,
      branchId: targetBranchId,
      userId: caller.id,
      action: "USER_CREATED",
      targetEntity: "User",
      targetEntityId: createdUser.id,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
      metadata: {
        createdUserId: createdUser.id,
        email: createdUser.email,
        scope: targetScope,
        branchId: targetBranchId,
        rolesAssigned: input.roleIds || [],
      },
    });

    // 7. Return complete user details
    const fullUser = await this.users.findByIdWithDetails(createdUser.id);
    return this.formatUserDetails(fullUser);
  }

  /**
   * List paginated users with role, branch, and status filtering.
   * - Branch users can only view users in their own branch.
   * - Organization users can view across all branches or filter by branch.
   */
  async listUsers(
    caller: SanitizedUserWithDetails,
    input: ListUsersInput
  ): Promise<{
    data: SanitizedUserWithDetails[];
    meta: {
      total: number;
      page: number;
      limit: number;
      totalPages: number;
    };
  }> {
    // Resolve tenancy boundary filter
    const { scope: effectiveScope, branchId: effectiveBranchId } =
      this.scope.resolveQueryScope(caller, {
        scope: input.scope,
        branchId: input.branchId,
      });

    const skip = (input.page - 1) * input.limit;
    const take = input.limit;

    const [users, total] = await Promise.all([
      this.users.findManyWithDetails({
        organizationId: caller.organizationId,
        branchId: effectiveBranchId,
        scope: effectiveScope,
        status: input.status as UserStatus | undefined,
        search: input.search,
        roleId: input.roleId,
        skip,
        take,
      }),
      this.users.count({
        organizationId: caller.organizationId,
        branchId: effectiveBranchId,
        scope: effectiveScope,
        status: input.status as UserStatus | undefined,
        search: input.search,
        roleId: input.roleId,
      }),
    ]);

    return {
      data: users.map((u) => this.formatUserDetails(u)),
      meta: {
        total,
        page: input.page,
        limit: input.limit,
        totalPages: Math.ceil(total / input.limit) || 1,
      },
    };
  }

  /**
   * Retrieve single user details by ID.
   */
  async getUserById(
    caller: SanitizedUserWithDetails,
    targetUserId: string
  ): Promise<SanitizedUserWithDetails> {
    const user = await this.users.findByIdWithDetails(targetUserId);
    this.scope.assertEntityAccess(caller, user, "User");
    return this.formatUserDetails(user);
  }

  /**
   * Update user status (ACTIVE, INACTIVE, SUSPENDED).
   */
  async updateUserStatus(
    caller: SanitizedUserWithDetails,
    targetUserId: string,
    input: UpdateUserStatusInput,
    req: Request
  ): Promise<SanitizedUserWithDetails> {
    if (caller.id === targetUserId) {
      throw new ErrorResponse(
        "You cannot change your own account status",
        statusCode.Bad_Request
      );
    }

    const targetUser = await this.users.findById(targetUserId);
    this.scope.assertEntityAccess(caller, targetUser, "User");

    const updated = await this.users.updateStatus(
      targetUser!.id,
      input.status as UserStatus
    );

    // Audit log
    await this.auditLogs.create({
      organizationId: caller.organizationId,
      branchId: targetUser!.branchId,
      userId: caller.id,
      action: input.status === "SUSPENDED" ? "USER_SUSPENDED" : "USER_UPDATED",
      targetEntity: "User",
      targetEntityId: updated.id,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
      metadata: {
        previousStatus: targetUser!.status,
        newStatus: input.status,
      },
    });

    const fullUser = await this.users.findByIdWithDetails(updated.id);
    return this.formatUserDetails(fullUser);
  }
}

export const userManagementService = new UserManagementService();
