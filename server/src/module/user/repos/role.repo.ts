import { prisma } from "../../../lib/prisma.js";
import type { Permission, Role, Scope } from "../../../types/types.js";

export class RoleRepo {
  /**
   * Create a new role with optional initial permissions in a transaction.
   */
  async create(data: {
    organizationId: string;
    branchId?: string | null | undefined;
    scope: Scope;
    name: string;
    slug: string;
    description?: string | null | undefined;
    permissionIds?: string[] | undefined;
  }): Promise<Role> {
    const createData: any = {
      organizationId: data.organizationId,
      branchId: data.branchId ?? null,
      scope: data.scope,
      name: data.name,
      slug: data.slug,
      description: data.description ?? null,
    };

    if (data.permissionIds && data.permissionIds.length > 0) {
      createData.rolePermissions = {
        create: data.permissionIds.map((permissionId) => ({
          permissionId,
        })),
      };
    }

    return prisma.role.create({
      data: createData,
      include: {
        rolePermissions: {
          include: {
            permission: true,
          },
        },
      },
    });
  }

  /**
   * Find role by ID with permissions eager-loaded.
   */
  async findById(id: string, organizationId?: string) {
    return prisma.role.findFirst({
      where: {
        id,
        ...(organizationId ? { organizationId } : {}),
        deletedAt: null,
      },
      include: {
        rolePermissions: {
          include: {
            permission: true,
          },
        },
      },
    });
  }

  /**
   * Find role by unique scope boundary (organizationId + branchId + slug).
   */
  async findBySlug(
    organizationId: string,
    branchId: string | null,
    slug: string
  ): Promise<Role | null> {
    return prisma.role.findFirst({
      where: {
        organizationId,
        branchId: branchId ?? null,
        slug,
        deletedAt: null,
      },
    });
  }

  /**
   * Query paginated roles with optional search and branch filtering.
   */
  async findMany(filter: {
    organizationId: string;
    branchId?: string | null | undefined;
    scope?: Scope | undefined;
    search?: string | undefined;
    skip: number;
    take: number;
  }) {
    const where: any = {
      organizationId: filter.organizationId,
      deletedAt: null,
    };

    if (filter.branchId !== undefined) {
      where.branchId = filter.branchId;
    }
    if (filter.scope !== undefined) {
      where.scope = filter.scope;
    }
    if (filter.search) {
      where.OR = [
        { name: { contains: filter.search, mode: "insensitive" } },
        { slug: { contains: filter.search, mode: "insensitive" } },
        { description: { contains: filter.search, mode: "insensitive" } },
      ];
    }

    return prisma.role.findMany({
      where,
      skip: filter.skip,
      take: filter.take,
      orderBy: { createdAt: "desc" },
      include: {
        rolePermissions: {
          include: {
            permission: true,
          },
        },
        _count: {
          select: { userRoles: true },
        },
      },
    });
  }

  /**
   * Count roles matching filter criteria.
   */
  async count(filter: {
    organizationId: string;
    branchId?: string | null | undefined;
    scope?: Scope | undefined;
    search?: string | undefined;
  }): Promise<number> {
    const where: any = {
      organizationId: filter.organizationId,
      deletedAt: null,
    };

    if (filter.branchId !== undefined) {
      where.branchId = filter.branchId;
    }
    if (filter.scope !== undefined) {
      where.scope = filter.scope;
    }
    if (filter.search) {
      where.OR = [
        { name: { contains: filter.search, mode: "insensitive" } },
        { slug: { contains: filter.search, mode: "insensitive" } },
        { description: { contains: filter.search, mode: "insensitive" } },
      ];
    }

    return prisma.role.count({ where });
  }

  /**
   * Replace/sync permissions assigned to a role in an ACID transaction.
   */
  async assignPermissions(roleId: string, permissionIds: string[]) {
    return prisma.$transaction(async (tx) => {
      // 1. Delete current mappings
      await tx.rolePermission.deleteMany({
        where: { roleId },
      });

      // 2. Insert new mappings
      if (permissionIds.length > 0) {
        await tx.rolePermission.createMany({
          data: permissionIds.map((permissionId) => ({
            roleId,
            permissionId,
          })),
        });
      }

      // 3. Return updated role
      return tx.role.findUnique({
        where: { id: roleId },
        include: {
          rolePermissions: {
            include: {
              permission: true,
            },
          },
        },
      });
    });
  }

  /**
   * Replace/sync roles assigned to a user in an ACID transaction.
   */
  async assignRolesToUser(userId: string, roleIds: string[]) {
    return prisma.$transaction(async (tx) => {
      // 1. Delete current mappings
      await tx.userRole.deleteMany({
        where: { userId },
      });

      // 2. Insert new mappings
      if (roleIds.length > 0) {
        await tx.userRole.createMany({
          data: roleIds.map((roleId) => ({
            userId,
            roleId,
          })),
        });
      }

      // 3. Return updated user
      return tx.user.findUnique({
        where: { id: userId },
        include: {
          userRoles: {
            include: {
              role: {
                include: {
                  rolePermissions: {
                    include: {
                      permission: true,
                    },
                  },
                },
              },
            },
          },
        },
      });
    });
  }

  /**
   * Look up permissions by their keys.
   */
  async findPermissionsByKeys(keys: string[]): Promise<Permission[]> {
    return prisma.permission.findMany({
      where: {
        key: { in: keys },
      },
    });
  }

  /**
   * Fetch all permissions, optionally filtered by scope.
   */
  async findAllPermissions(scope?: Scope): Promise<Permission[]> {
    return prisma.permission.findMany({
      where: scope
        ? {
            allowedScopes: { has: scope },
          }
        : {},
      orderBy: [{ module: "asc" }, { key: "asc" }],
    });
  }

  /**
   * Fetch multiple roles by their IDs within an organization.
   */
  async findManyByIds(ids: string[], organizationId: string): Promise<Role[]> {
    return prisma.role.findMany({
      where: {
        id: { in: ids },
        organizationId,
        deletedAt: null,
      },
    });
  }
}

export const roleRepo = new RoleRepo();
