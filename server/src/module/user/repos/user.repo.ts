import { prisma } from "../../../lib/prisma.js";
import type { Scope, User, UserStatus } from "../../../types/types.js";

export class UserRepo {
  /**
   * Find a user by email, optionally scoped by organizationId.
   */
  async findByEmail(email: string, organizationId?: string): Promise<User | null> {
    if (organizationId) {
      return prisma.user.findFirst({
        where: {
          email,
          organizationId,
          deletedAt: null,
        },
      });
    }

    return prisma.user.findFirst({
      where: {
        email,
        deletedAt: null,
      },
    });
  }

  /**
   * Find raw user by primary key ID.
   */
  async findById(id: string): Promise<User | null> {
    return prisma.user.findUnique({
      where: { id, deletedAt: null },
    });
  }

  /**
   * Find user by ID with eager loaded relations (Organization, Branch, Roles, Permissions, Persona links).
   */
  async findByIdWithDetails(id: string) {
    return prisma.user.findUnique({
      where: { id, deletedAt: null },
      include: {
        organization: {
          select: {
            id: true,
            name: true,
            slug: true,
            logo: true,
          },
        },
        branch: {
          select: {
            id: true,
            name: true,
            slug: true,
            code: true,
          },
        },
        userRoles: {
          select: {
            role: {
              select: {
                id: true,
                name: true,
                slug: true,
                scope: true,
                description: true,
                rolePermissions: {
                  select: {
                    permission: {
                      select: {
                        id: true,
                        key: true,
                        name: true,
                        module: true,
                        action: true,
                      },
                    },
                  },
                },
              },
            },
          },
        },
        student: {
          select: {
            id: true,
            enrollmentNo: true,
            applicationNo: true,
            admissionStatus: true,
          },
        },
        teacher: {
          select: {
            id: true,
            employeeCode: true,
            designation: true,
            status: true,
          },
        },
        parent: {
          select: {
            id: true,
            occupation: true,
          },
        },
      },
    });
  }

  /**
   * Update user basic profile information.
   */
  async updateProfile(
    id: string,
    data: {
      firstName?: string | undefined;
      lastName?: string | null | undefined;
      phone?: string | null | undefined;
      avatar?: string | null | undefined;
    }
  ): Promise<User> {
    const updateData: any = {};
    if (data.firstName !== undefined) updateData.firstName = data.firstName;
    if (data.lastName !== undefined) updateData.lastName = data.lastName;
    if (data.phone !== undefined) updateData.phone = data.phone;
    if (data.avatar !== undefined) updateData.avatar = data.avatar;

    return prisma.user.update({
      where: { id },
      data: updateData,
    });
  }

  /**
   * Update password hash.
   */
  async updatePassword(id: string, passwordHash: string): Promise<User> {
    return prisma.user.update({
      where: { id },
      data: { passwordHash },
    });
  }

  /**
   * Update last login timestamp.
   */
  async updateLastLogin(id: string): Promise<void> {
    await prisma.user.update({
      where: { id },
      data: { lastLoginAt: new Date() },
    });
  }

  /**
   * Create a new user with optional initial role assignments.
   */
  async create(data: {
    organizationId: string;
    branchId?: string | null | undefined;
    scope: Scope;
    email: string;
    passwordHash: string;
    firstName: string;
    lastName?: string | null | undefined;
    phone?: string | null | undefined;
    status?: UserStatus | undefined;
    roleIds?: string[] | undefined;
  }): Promise<User> {
    const createData: any = {
      organizationId: data.organizationId,
      branchId: data.branchId ?? null,
      scope: data.scope,
      email: data.email,
      passwordHash: data.passwordHash,
      firstName: data.firstName,
      lastName: data.lastName ?? null,
      phone: data.phone ?? null,
      status: data.status || "ACTIVE",
    };

    if (data.roleIds && data.roleIds.length > 0) {
      createData.userRoles = {
        create: data.roleIds.map((roleId) => ({
          roleId,
        })),
      };
    }

    return prisma.user.create({
      data: createData,
    });
  }

  /**
   * Query paginated users with eager-loaded relations and filters.
   */
  async findManyWithDetails(filter: {
    organizationId: string;
    branchId?: string | null | undefined;
    scope?: Scope | undefined;
    status?: UserStatus | undefined;
    search?: string | undefined;
    roleId?: string | undefined;
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
    if (filter.status !== undefined) {
      where.status = filter.status;
    }
    if (filter.roleId) {
      where.userRoles = {
        some: { roleId: filter.roleId },
      };
    }
    if (filter.search) {
      where.OR = [
        { firstName: { contains: filter.search, mode: "insensitive" } },
        { lastName: { contains: filter.search, mode: "insensitive" } },
        { email: { contains: filter.search, mode: "insensitive" } },
        { phone: { contains: filter.search, mode: "insensitive" } },
      ];
    }

    return prisma.user.findMany({
      where,
      skip: filter.skip,
      take: filter.take,
      orderBy: { createdAt: "desc" },
      include: {
        organization: {
          select: { id: true, name: true, slug: true, logo: true },
        },
        branch: {
          select: { id: true, name: true, slug: true, code: true },
        },
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
        student: {
          select: {
            id: true,
            enrollmentNo: true,
            applicationNo: true,
            admissionStatus: true,
          },
        },
        teacher: {
          select: {
            id: true,
            employeeCode: true,
            designation: true,
            status: true,
          },
        },
        parent: {
          select: {
            id: true,
            occupation: true,
          },
        },
      },
    });
  }

  /**
   * Count users matching filter conditions.
   */
  async count(filter: {
    organizationId: string;
    branchId?: string | null | undefined;
    scope?: Scope | undefined;
    status?: UserStatus | undefined;
    search?: string | undefined;
    roleId?: string | undefined;
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
    if (filter.status !== undefined) {
      where.status = filter.status;
    }
    if (filter.roleId) {
      where.userRoles = {
        some: { roleId: filter.roleId },
      };
    }
    if (filter.search) {
      where.OR = [
        { firstName: { contains: filter.search, mode: "insensitive" } },
        { lastName: { contains: filter.search, mode: "insensitive" } },
        { email: { contains: filter.search, mode: "insensitive" } },
        { phone: { contains: filter.search, mode: "insensitive" } },
      ];
    }

    return prisma.user.count({ where });
  }

  /**
   * Update user lifecycle status (ACTIVE, INACTIVE, SUSPENDED).
   */
  async updateStatus(id: string, status: UserStatus): Promise<User> {
    return prisma.user.update({
      where: { id },
      data: { status },
    });
  }
}

export const userRepo = new UserRepo();
