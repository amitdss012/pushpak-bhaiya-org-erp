import type { Request } from "express";
import { Scope, statusCode } from "../../../types/types.js";
import { ErrorResponse } from "../../../utils/response.util.js";
import { auditLogRepo, type AuditLogRepo } from "../repos/audit-log.repo.js";
import { roleRepo, type RoleRepo } from "../repos/role.repo.js";
import { userRepo, type UserRepo } from "../repos/user.repo.js";
import type { SanitizedUserWithDetails } from "../types/user.types.js";
import type {
  AssignPermissionsToRoleInput,
  AssignRolesToUserInput,
  CreateRoleInput,
  ListRolesInput,
} from "../validators/user.validator.js";
import { userScopeService, type UserScopeService } from "./user.scope.service.js";

export class UserRoleService {
  constructor(
    private readonly roles: RoleRepo = roleRepo,
    private readonly users: UserRepo = userRepo,
    private readonly auditLogs: AuditLogRepo = auditLogRepo,
    private readonly scope: UserScopeService = userScopeService
  ) {}

  /**
   * Slugify a role name string into URL-friendly identifier.
   */
  private slugify(text: string): string {
    return text
      .toLowerCase()
      .trim()
      .replace(/[^\w\s-]/g, "")
      .replace(/[\s_-]+/g, "-")
      .replace(/^-+|-+$/g, "");
  }

  /**
   * Helper to append a flat permissions array of keys to role responses.
   */
  private formatRoleWithPermissions<T extends Record<string, any>>(role: T) {
    if (!role) return role;
    const roleWithPerms = role as T & { rolePermissions?: any[] };
    const permissions = (roleWithPerms.rolePermissions || [])
      .map((rp: any) => rp.permission?.key || rp.permissionKey || rp.permissionId)
      .filter(Boolean);
    return {
      ...role,
      permissions,
    };
  }

  /**
   * Create a new role with scope-based multi-tenant enforcement.
   * - Organization user can create org-wide or branch-specific roles.
   * - Branch user can only create roles for their own branch.
   */
  async createRole(
    caller: SanitizedUserWithDetails,
    input: CreateRoleInput,
    req: Request
  ) {
    // 1. Enforce Multi-Tenant Scope Boundaries via Scope Service
    const { scope: targetScope, branchId: targetBranchId } =
      await this.scope.resolveTargetScopeAndBranch(caller, {
        scope: input.scope,
        branchId: input.branchId,
      });

    // 2. Generate slug and check scope boundary uniqueness
    const slug = this.slugify(input.name);
    const existingSlug = await this.roles.findBySlug(
      caller.organizationId,
      targetBranchId,
      slug
    );

    if (existingSlug) {
      throw new ErrorResponse(
        `A role with the name '${input.name}' (slug: '${slug}') already exists in this ${targetScope.toLowerCase()}`,
        statusCode.Conflict
      );
    }

    // 3. Validate permissions & scope applicability if provided
    let permissionIds: string[] | undefined;
    if (input.permissionKeys && input.permissionKeys.length > 0) {
      const permissions = await this.roles.findPermissionsByKeys(
        input.permissionKeys
      );

      if (permissions.length !== input.permissionKeys.length) {
        const foundKeys = new Set(permissions.map((p) => p.key));
        const missingKeys = input.permissionKeys.filter((k) => !foundKeys.has(k));
        throw new ErrorResponse(
          `Unknown permission keys: ${missingKeys.join(", ")}`,
          statusCode.Bad_Request
        );
      }

      // Ensure every permission is allowed for the target role scope
      for (const perm of permissions) {
        if (!perm.allowedScopes.includes(targetScope)) {
          throw new ErrorResponse(
            `Permission '${perm.key}' is only valid for scopes [${perm.allowedScopes.join(", ")}], not '${targetScope}'`,
            statusCode.Bad_Request
          );
        }
      }

      permissionIds = permissions.map((p) => p.id);
    }

    // 4. Persist role
    const createdRole = await this.roles.create({
      organizationId: caller.organizationId,
      branchId: targetBranchId,
      scope: targetScope,
      name: input.name,
      slug,
      description: input.description ?? null,
      permissionIds,
    });

    // 5. Audit Log
    await this.auditLogs.create({
      organizationId: caller.organizationId,
      branchId: targetBranchId,
      userId: caller.id,
      action: "ROLE_ASSIGNED",
      targetEntity: "Role",
      targetEntityId: createdRole.id,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
      metadata: {
        roleId: createdRole.id,
        roleName: createdRole.name,
        slug,
        scope: targetScope,
        branchId: targetBranchId,
        permissionsCount: permissionIds?.length || 0,
      },
    });

    return this.formatRoleWithPermissions(createdRole);
  }

  /**
   * List paginated roles.
   * - Branch users can only view branch roles within their branch.
   * - Organization users can view across org or filter by branch.
   */
  async listRoles(caller: SanitizedUserWithDetails, input: ListRolesInput) {
    const { scope: effectiveScope, branchId: effectiveBranchId } =
      this.scope.resolveQueryScope(caller, {
        scope: input.scope,
        branchId: input.branchId,
      });

    const skip = (input.page - 1) * input.limit;
    const take = input.limit;

    const [roles, total] = await Promise.all([
      this.roles.findMany({
        organizationId: caller.organizationId,
        branchId: effectiveBranchId,
        scope: effectiveScope,
        search: input.search,
        skip,
        take,
      }),
      this.roles.count({
        organizationId: caller.organizationId,
        branchId: effectiveBranchId,
        scope: effectiveScope,
        search: input.search,
      }),
    ]);

    const formattedRoles = roles.map((role) =>
      this.formatRoleWithPermissions(role)
    );

    return {
      data: formattedRoles,
      meta: {
        total,
        page: input.page,
        limit: input.limit,
        totalPages: Math.ceil(total / input.limit) || 1,
      },
    };
  }

  /**
   * Retrieve role by ID with permissions.
   */
  async getRoleById(caller: SanitizedUserWithDetails, roleId: string) {
    const role = await this.roles.findById(roleId, caller.organizationId);
    this.scope.assertEntityAccess(caller, role, "Role");
    return this.formatRoleWithPermissions(role!);
  }

  /**
   * Assign/sync atomic permissions to an existing role.
   */
  async assignPermissionsToRole(
    caller: SanitizedUserWithDetails,
    roleId: string,
    input: AssignPermissionsToRoleInput,
    req: Request
  ) {
    const role = await this.roles.findById(roleId, caller.organizationId);
    this.scope.assertEntityAccess(caller, role, "Role");

    // Validate permission keys
    const permissions = await this.roles.findPermissionsByKeys(
      input.permissionKeys
    );

    if (permissions.length !== input.permissionKeys.length) {
      const foundKeys = new Set(permissions.map((p) => p.key));
      const missingKeys = input.permissionKeys.filter((k) => !foundKeys.has(k));
      throw new ErrorResponse(
        `Unknown permission keys: ${missingKeys.join(", ")}`,
        statusCode.Bad_Request
      );
    }

    // Scope check: ensure permissions are applicable to role's scope
    for (const perm of permissions) {
      if (!perm.allowedScopes.includes(role!.scope)) {
        throw new ErrorResponse(
          `Permission '${perm.key}' cannot be assigned to role '${role!.name}': Not allowed for scope '${role!.scope}'`,
          statusCode.Bad_Request
        );
      }
    }

    const permissionIds = permissions.map((p) => p.id);
    const updatedRole = await this.roles.assignPermissions(role!.id, permissionIds);

    // Audit log
    await this.auditLogs.create({
      organizationId: caller.organizationId,
      branchId: role!.branchId,
      userId: caller.id,
      action: "PERMISSION_CHANGED",
      targetEntity: "Role",
      targetEntityId: role!.id,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
      metadata: {
        roleId: role!.id,
        roleName: role!.name,
        permissionKeys: input.permissionKeys,
      },
    });

    return this.formatRoleWithPermissions(updatedRole!);
  }

  /**
   * Assign roles to a user with strict scope matching:
   * - Target user and role must have matching scopes.
   * - Branch users can only be assigned roles within their branch.
   */
  async assignRolesToUser(
    caller: SanitizedUserWithDetails,
    targetUserId: string,
    input: AssignRolesToUserInput,
    req: Request
  ) {
    const targetUser = await this.users.findByIdWithDetails(targetUserId);
    this.scope.assertEntityAccess(caller, targetUser, "User");

    // Validate roles
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

    // Scope matching validation via Scope Service
    this.scope.assertRoleScopeCompatibility(
      { scope: targetUser!.scope, branchId: targetUser!.branchId },
      roles,
      caller
    );

    await this.roles.assignRolesToUser(targetUser!.id, input.roleIds);

    // Audit log
    await this.auditLogs.create({
      organizationId: caller.organizationId,
      branchId: targetUser!.branchId,
      userId: caller.id,
      action: "ROLE_ASSIGNED",
      targetEntity: "User",
      targetEntityId: targetUser!.id,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
      metadata: {
        userId: targetUser!.id,
        roleIds: input.roleIds,
        roleNames: roles.map((r) => r.name),
      },
    });

    return this.users.findByIdWithDetails(targetUser!.id);
  }

  /**
   * List all system permissions for UI selectors, filtered by caller's scope.
   */
  async listPermissions(caller: SanitizedUserWithDetails) {
    const scopeFilter = caller.scope === Scope.BRANCH ? Scope.BRANCH : undefined;
    const permissions = await this.roles.findAllPermissions(scopeFilter);

    // Group by module for easy frontend consumption
    const grouped: Record<string, typeof permissions> = {};
    for (const perm of permissions) {
      if (!grouped[perm.module]) {
        grouped[perm.module] = [];
      }
      grouped[perm.module]!.push(perm);
    }

    return {
      total: permissions.length,
      permissions,
      groupedByModule: grouped,
    };
  }
}

export const userRoleService = new UserRoleService();
