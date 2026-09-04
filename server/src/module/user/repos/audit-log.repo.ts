import { prisma } from "../../../lib/prisma.js";
import type { AuditAction, AuditLog } from "../../../types/types.js";

export interface CreateAuditLogData {
  organizationId: string;
  branchId?: string | null | undefined;
  userId?: string | null | undefined;
  action: AuditAction;
  targetEntity?: string | null | undefined;
  targetEntityId?: string | null | undefined;
  ipAddress?: string | null | undefined;
  userAgent?: string | null | undefined;
  metadata?: any;
}

export class AuditLogRepo {
  /**
   * Insert an immutable audit log record.
   */
  async create(data: CreateAuditLogData): Promise<AuditLog> {
    return prisma.auditLog.create({
      data: {
        organizationId: data.organizationId,
        branchId: data.branchId ?? null,
        userId: data.userId ?? null,
        action: data.action,
        targetEntity: data.targetEntity ?? null,
        targetEntityId: data.targetEntityId ?? null,
        ipAddress: data.ipAddress ?? null,
        userAgent: data.userAgent ?? null,
        metadata: data.metadata !== undefined ? (data.metadata as any) : undefined,
      },
    });
  }

  /**
   * Fetch paginated audit logs for a specific user.
   */
  async findUserLogs(
    userId: string,
    page: number = 1,
    limit: number = 20
  ): Promise<{ logs: AuditLog[]; total: number; page: number; totalPages: number }> {
    const skip = (page - 1) * limit;

    const [logs, total] = await Promise.all([
      prisma.auditLog.findMany({
        where: { userId },
        orderBy: { createdAt: "desc" },
        skip,
        take: limit,
      }),
      prisma.auditLog.count({
        where: { userId },
      }),
    ]);

    return {
      logs,
      total,
      page,
      totalPages: Math.ceil(total / limit),
    };
  }
}

export const auditLogRepo = new AuditLogRepo();
