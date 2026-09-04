import { prisma } from "../../../lib/prisma.js";
import { Scope, statusCode } from "../../../types/types.js";
import { ErrorResponse } from "../../../utils/response.util.js";

/**
 * Minimal user representation required for scope validation.
 */
export interface ScopeContextUser {
  id: string;
  organizationId: string;
  branchId: string | null;
  scope: Scope;
}

/**
 * Dedicated service for validating and enforcing multi-tenant scope boundaries.
 * Enforces that:
 * - Branch-level actors can never perform organization-level actions or touch other branches.
 * - Organization-level actors can perform org-wide actions or target any branch within their org.
 * - Entities (users, roles, students, teachers, etc.) belong to the caller's tenancy boundaries.
 */
export class UserScopeService {
  /**
   * Resolve target scope and branch for an operation (e.g. creating/modifying a user, role, or resource).
   *
   * @throws ErrorResponse(403) If branch user attempts org action or targets another branch.
   * @throws ErrorResponse(404) If organization user targets a branch that doesn't exist in their tenant.
   */
  async resolveTargetScopeAndBranch(
    caller: ScopeContextUser,
    requested?: { scope?: Scope | string | undefined; branchId?: string | null | undefined }
  ): Promise<{ scope: Scope; branchId: string | null }> {
    // 1. Branch-scoped caller boundary
    if (caller.scope === Scope.BRANCH) {
      if (!caller.branchId) {
        throw new ErrorResponse(
          "Caller branch context is missing",
          statusCode.Unauthorized
        );
      }

      // Branch users can NEVER perform organization-level actions
      if (requested?.scope === Scope.ORGANIZATION) {
        throw new ErrorResponse(
          "Access denied: Branch staff cannot perform organization-level actions",
          statusCode.Forbidden
        );
      }

      // Branch users can NEVER target another branch
      if (requested?.branchId && requested.branchId !== caller.branchId) {
        throw new ErrorResponse(
          "Access denied: Branch staff can only perform actions within their assigned branch",
          statusCode.Forbidden
        );
      }

      return {
        scope: Scope.BRANCH,
        branchId: caller.branchId,
      };
    }

    // 2. Organization-scoped caller boundary
    if (requested?.branchId) {
      // Validate that target branch exists under the caller's organization
      const branch = await prisma.branch.findFirst({
        where: {
          id: requested.branchId,
          organizationId: caller.organizationId,
          deletedAt: null,
        },
      });

      if (!branch) {
        throw new ErrorResponse(
          "Specified branch was not found under your organization",
          statusCode.Not_Found
        );
      }

      return {
        scope: Scope.BRANCH,
        branchId: branch.id,
      };
    }

    // Default to organization-level
    return {
      scope: Scope.ORGANIZATION,
      branchId: null,
    };
  }

  /**
   * Assert that a target entity belongs to the caller's organization and branch boundaries.
   *
   * @throws ErrorResponse(404) If entity is null or belongs to a different organization.
   * @throws ErrorResponse(403) If caller is branch-scoped and entity is outside their branch.
   */
  assertEntityAccess(
    caller: ScopeContextUser,
    entity: { organizationId: string; branchId?: string | null } | null | undefined,
    entityName: string = "Resource"
  ): void {
    if (!entity || entity.organizationId !== caller.organizationId) {
      throw new ErrorResponse(`${entityName} not found`, statusCode.Not_Found);
    }

    if (caller.scope === Scope.BRANCH && entity.branchId !== caller.branchId) {
      throw new ErrorResponse(
        `Access denied: You can only access ${entityName.toLowerCase()}s within your assigned branch`,
        statusCode.Forbidden
      );
    }
  }

  /**
   * Resolve scope filter for list queries.
   * - Forcefully restricts branch users to their own branch.
   * - Allows organization users to filter by branch or view all branches.
   */
  resolveQueryScope(
    caller: ScopeContextUser,
    requested?: { scope?: Scope | undefined; branchId?: string | undefined }
  ): { scope?: Scope | undefined; branchId?: string | undefined } {
    if (caller.scope === Scope.BRANCH) {
      const result: { scope?: Scope | undefined; branchId?: string | undefined } = {
        scope: Scope.BRANCH,
      };
      if (caller.branchId) {
        result.branchId = caller.branchId;
      }
      return result;
    }

    const result: { scope?: Scope | undefined; branchId?: string | undefined } = {};
    if (requested?.scope !== undefined) result.scope = requested.scope;
    if (requested?.branchId !== undefined) result.branchId = requested.branchId;
    return result;
  }

  /**
   * Validate that roles being assigned to a target user match scope boundaries.
   *
   * @throws ErrorResponse(400) If role scope does not match user scope.
   * @throws ErrorResponse(403) If branch caller attempts to assign a role outside their branch.
   */
  assertRoleScopeCompatibility(
    target: { scope: Scope; branchId: string | null },
    roles: Array<{ name: string; scope: Scope; branchId: string | null }>,
    caller?: ScopeContextUser
  ): void {
    for (const role of roles) {
      if (caller && caller.scope === Scope.BRANCH) {
        if (role.scope !== Scope.BRANCH || role.branchId !== caller.branchId) {
          throw new ErrorResponse(
            `Role '${role.name}' cannot be assigned: Branch staff can only assign roles from their own branch`,
            statusCode.Forbidden
          );
        }
      }

      if (target.scope === Scope.ORGANIZATION && role.scope !== Scope.ORGANIZATION) {
        throw new ErrorResponse(
          `Role '${role.name}' is branch-scoped and cannot be assigned to an organization-level user`,
          statusCode.Bad_Request
        );
      }

      if (target.scope === Scope.BRANCH) {
        if (role.scope !== Scope.BRANCH || role.branchId !== target.branchId) {
          throw new ErrorResponse(
            `Role '${role.name}' cannot be assigned: Branch users can only hold roles matching their specific branch`,
            statusCode.Bad_Request
          );
        }
      }
    }
  }
}

export const userScopeService = new UserScopeService();
