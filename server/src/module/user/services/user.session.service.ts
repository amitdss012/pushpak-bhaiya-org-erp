import type { Request } from "express";
import { statusCode } from "../../../types/types.js";
import { ErrorResponse } from "../../../utils/response.util.js";
import { auditLogRepo, type AuditLogRepo } from "../repos/audit-log.repo.js";
import { refreshTokenRepo, type RefreshTokenRepo } from "../repos/refresh-token.repo.js";
import type { ActiveSessionItem } from "../types/user.types.js";

export class UserSessionService {
  constructor(
    private readonly sessions: RefreshTokenRepo = refreshTokenRepo,
    private readonly auditLogs: AuditLogRepo = auditLogRepo
  ) {}

  /**
   * Retrieve all active device sessions for the authenticated user.
   */
  async getActiveSessions(
    userId: string,
    currentSessionId?: string
  ): Promise<ActiveSessionItem[]> {
    const rawSessions = await this.sessions.findActiveSessionsByUserId(userId);

    return rawSessions.map((session) => ({
      id: session.id,
      deviceId: session.deviceId,
      deviceType: session.deviceType,
      deviceName: session.deviceName,
      browser: session.browser,
      browserVersion: session.browserVersion,
      os: session.os,
      osVersion: session.osVersion,
      ipAddress: session.ipAddress,
      location: session.location,
      loginAt: session.loginAt,
      lastActiveAt: session.lastActiveAt,
      isCurrent: session.id === currentSessionId,
    }));
  }

  /**
   * Terminate a specific device session.
   */
  async revokeSession(
    userId: string,
    sessionId: string,
    req?: Request
  ): Promise<{ message: string }> {
    const session = await this.sessions.findById(sessionId);
    if (!session || session.userId !== userId) {
      throw new ErrorResponse("Session not found", statusCode.Not_Found);
    }

    if (session.revokedAt) {
      return { message: "Session is already terminated" };
    }

    await this.sessions.revoke(sessionId, "manual_remote_logout");

    await this.auditLogs.create({
      organizationId: (req?.user as any)?.organizationId || "",
      branchId: (req?.user as any)?.branchId || null,
      userId,
      action: "LOGOUT",
      ipAddress: req?.ip,
      userAgent: req?.headers["user-agent"],
      metadata: { revokedSessionId: sessionId, method: "remote_device_revocation" },
    });

    return { message: "Device session has been terminated" };
  }

  /**
   * Get paginated security activity logs for the user.
   */
  async getActivityLogs(userId: string, page: number = 1, limit: number = 20) {
    return this.auditLogs.findUserLogs(userId, page, limit);
  }
}

export const userSessionService = new UserSessionService();
