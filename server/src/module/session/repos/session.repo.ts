import { prisma } from "../../../lib/prisma.js";
import type { Prisma } from "../../../types/types.js";
import type {
  AcademicSessionWithDetails,
  BranchAcademicSessionWithDetails,
  PaginatedSessionsResult,
} from "../types/session.types.js";

export class SessionRepo {
  private static creatorSelect = {
    id: true,
    firstName: true,
    lastName: true,
    email: true,
  } as const;

  private static branchSelect = {
    id: true,
    name: true,
    slug: true,
    code: true,
  } as const;

  /**
   * Find paginated academic sessions for an organization with branch mappings and creator details.
   */
  async findMany(
    organizationId: string,
    filter: {
      branchId?: string | undefined;
      search?: string | undefined;
      page: number;
      limit: number;
    }
  ): Promise<PaginatedSessionsResult> {
    const { branchId, search, page, limit } = filter;
    const skip = (page - 1) * limit;

    const where: Prisma.AcademicSessionWhereInput = {
      organizationId,
      deletedAt: null,
    };

    if (branchId) {
      where.branchMappings = {
        some: {
          branchId,
          deletedAt: null,
        },
      };
    }

    if (search && search.trim().length > 0) {
      where.OR = [
        { name: { contains: search.trim(), mode: "insensitive" } },
        { code: { contains: search.trim(), mode: "insensitive" } },
      ];
    }

    const [total, sessions] = await prisma.$transaction([
      prisma.academicSession.count({ where }),
      prisma.academicSession.findMany({
        where,
        skip,
        take: limit,
        orderBy: [{ startYear: "desc" }, { startDate: "desc" }],
        include: {
          createdBy: { select: SessionRepo.creatorSelect },
          branchMappings: {
            where: { deletedAt: null },
            include: {
              branch: { select: SessionRepo.branchSelect },
              createdBy: { select: SessionRepo.creatorSelect },
            },
          },
        },
      }),
    ]);

    return {
      sessions: sessions as unknown as AcademicSessionWithDetails[],
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit) || 1,
      },
    };
  }

  /**
   * Find a single academic session by ID within an organization.
   */
  async findById(
    id: string,
    organizationId: string
  ): Promise<AcademicSessionWithDetails | null> {
    const session = await prisma.academicSession.findFirst({
      where: {
        id,
        organizationId,
        deletedAt: null,
      },
      include: {
        createdBy: { select: SessionRepo.creatorSelect },
        branchMappings: {
          where: { deletedAt: null },
          include: {
            branch: { select: SessionRepo.branchSelect },
            createdBy: { select: SessionRepo.creatorSelect },
          },
        },
      },
    });

    return (session as unknown as AcademicSessionWithDetails) || null;
  }

  /**
   * Find an academic session by unique name within an organization.
   */
  async findByName(
    name: string,
    organizationId: string
  ): Promise<AcademicSessionWithDetails | null> {
    const session = await prisma.academicSession.findFirst({
      where: {
        name,
        organizationId,
        deletedAt: null,
      },
      include: {
        createdBy: { select: SessionRepo.creatorSelect },
        branchMappings: {
          where: { deletedAt: null },
          include: {
            branch: { select: SessionRepo.branchSelect },
            createdBy: { select: SessionRepo.creatorSelect },
          },
        },
      },
    });

    return (session as unknown as AcademicSessionWithDetails) || null;
  }

  /**
   * Create master AcademicSession and map it to specified branches atomically.
   */
  async create(
    data: {
      organizationId: string;
      name: string;
      code?: string | null | undefined;
      startYear: number;
      endYear: number;
      startDate: Date;
      endDate: Date;
      description?: string | null | undefined;
      createdById?: string | null | undefined;
    },
    branchIds: string[] = [],
    isCurrentForBranches = false
  ): Promise<AcademicSessionWithDetails> {
    return prisma.$transaction(async (tx) => {
      // 1. Create master session
      const session = await tx.academicSession.create({
        data: {
          organizationId: data.organizationId,
          name: data.name,
          code: data.code ?? null,
          startYear: data.startYear,
          endYear: data.endYear,
          startDate: data.startDate,
          endDate: data.endDate,
          description: data.description ?? null,
          createdById: data.createdById ?? null,
        },
      });

      // 2. Map branches if provided
      if (branchIds.length > 0) {
        for (const branchId of branchIds) {
          if (isCurrentForBranches) {
            // Unset current session for this branch first
            await tx.branchAcademicSession.updateMany({
              where: { branchId, deletedAt: null },
              data: { isCurrent: false },
            });
          }

          await tx.branchAcademicSession.create({
            data: {
              academicSessionId: session.id,
              branchId,
              isCurrent: isCurrentForBranches,
              createdById: data.createdById ?? null,
            },
          });
        }
      }

      // 3. Return created session with details
      const result = await tx.academicSession.findUniqueOrThrow({
        where: { id: session.id },
        include: {
          createdBy: { select: SessionRepo.creatorSelect },
          branchMappings: {
            where: { deletedAt: null },
            include: {
              branch: { select: SessionRepo.branchSelect },
              createdBy: { select: SessionRepo.creatorSelect },
            },
          },
        },
      });

      return result as unknown as AcademicSessionWithDetails;
    });
  }

  /**
   * Update master AcademicSession metadata.
   */
  async update(
    id: string,
    organizationId: string,
    data: Prisma.AcademicSessionUpdateInput
  ): Promise<AcademicSessionWithDetails> {
    const updated = await prisma.academicSession.update({
      where: { id, organizationId },
      data,
      include: {
        createdBy: { select: SessionRepo.creatorSelect },
        branchMappings: {
          where: { deletedAt: null },
          include: {
            branch: { select: SessionRepo.branchSelect },
            createdBy: { select: SessionRepo.creatorSelect },
          },
        },
      },
    });

    return updated as unknown as AcademicSessionWithDetails;
  }

  /**
   * Map branches to an academic session.
   */
  async mapBranches(
    academicSessionId: string,
    branchIds: string[],
    isCurrent: boolean,
    createdById: string | null
  ): Promise<void> {
    await prisma.$transaction(async (tx) => {
      for (const branchId of branchIds) {
        if (isCurrent) {
          await tx.branchAcademicSession.updateMany({
            where: { branchId, deletedAt: null },
            data: { isCurrent: false },
          });
        }

        const existing = await tx.branchAcademicSession.findFirst({
          where: {
            academicSessionId,
            branchId,
          },
        });

        if (existing) {
          await tx.branchAcademicSession.update({
            where: { id: existing.id },
            data: {
              deletedAt: null,
              isCurrent,
            },
          });
        } else {
          await tx.branchAcademicSession.create({
            data: {
              academicSessionId,
              branchId,
              isCurrent,
              createdById,
            },
          });
        }
      }
    });
  }

  /**
   * Set a branch's active/current session.
   */
  async setBranchCurrentSession(
    branchId: string,
    branchAcademicSessionId: string
  ): Promise<BranchAcademicSessionWithDetails> {
    return prisma.$transaction(async (tx) => {
      // Unset current session for the branch
      await tx.branchAcademicSession.updateMany({
        where: { branchId, deletedAt: null },
        data: { isCurrent: false },
      });

      // Set the chosen mapping as current
      const updated = await tx.branchAcademicSession.update({
        where: { id: branchAcademicSessionId },
        data: { isCurrent: true },
        include: {
          branch: { select: SessionRepo.branchSelect },
          createdBy: { select: SessionRepo.creatorSelect },
        },
      });

      return updated as unknown as BranchAcademicSessionWithDetails;
    });
  }

  /**
   * Get the current active session mapping for a branch.
   */
  async findCurrentSessionForBranch(
    branchId: string
  ): Promise<BranchAcademicSessionWithDetails | null> {
    const current = await prisma.branchAcademicSession.findFirst({
      where: {
        branchId,
        isCurrent: true,
        deletedAt: null,
      },
      include: {
        branch: { select: SessionRepo.branchSelect },
        createdBy: { select: SessionRepo.creatorSelect },
        academicSession: true,
      },
    });

    return (current as unknown as BranchAcademicSessionWithDetails) || null;
  }

  /**
   * Soft-delete an academic session and its branch mappings.
   */
  async softDelete(id: string, organizationId: string): Promise<void> {
    const now = new Date();
    await prisma.$transaction([
      prisma.academicSession.update({
        where: { id, organizationId },
        data: { deletedAt: now },
      }),
      prisma.branchAcademicSession.updateMany({
        where: { academicSessionId: id, deletedAt: null },
        data: { deletedAt: now, isCurrent: false },
      }),
    ]);
  }
}

export const sessionRepo = new SessionRepo();
