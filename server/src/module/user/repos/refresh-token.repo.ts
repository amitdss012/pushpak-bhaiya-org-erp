import { prisma } from "../../../lib/prisma.js";
import type { DeviceType, RefreshToken, TokenType } from "../../../types/types.js";

export interface CreateSessionData {
  userId: string;
  refreshTokenHash: string;
  accessTokenHash?: string | null | undefined;
  type?: TokenType | undefined;
  expiresAt: Date;
  deviceId?: string | null | undefined;
  deviceType?: DeviceType | undefined;
  deviceName?: string | null | undefined;
  browser?: string | null | undefined;
  browserVersion?: string | null | undefined;
  os?: string | null | undefined;
  osVersion?: string | null | undefined;
  userAgent?: string | null | undefined;
  ipAddress?: string | null | undefined;
  location?: string | null | undefined;
}

export class RefreshTokenRepo {
  /**
   * Create a new session or token record.
   */
  async create(data: CreateSessionData): Promise<RefreshToken> {
    return prisma.refreshToken.create({
      data: {
        userId: data.userId,
        refreshTokenHash: data.refreshTokenHash,
        accessTokenHash: data.accessTokenHash ?? null,
        type: data.type || "REFRESH",
        expiresAt: data.expiresAt,
        deviceId: data.deviceId ?? null,
        deviceType: data.deviceType || "UNKNOWN",
        deviceName: data.deviceName ?? null,
        browser: data.browser ?? null,
        browserVersion: data.browserVersion ?? null,
        os: data.os ?? null,
        osVersion: data.osVersion ?? null,
        userAgent: data.userAgent ?? null,
        ipAddress: data.ipAddress ?? null,
        location: data.location ?? null,
      },
    });
  }

  /**
   * Find token record by its SHA-256 hash.
   */
  async findByTokenHash(refreshTokenHash: string): Promise<RefreshToken | null> {
    return prisma.refreshToken.findUnique({
      where: { refreshTokenHash },
    });
  }

  /**
   * Find all currently active device sessions for a given user.
   */
  async findActiveSessionsByUserId(userId: string): Promise<RefreshToken[]> {
    return prisma.refreshToken.findMany({
      where: {
        userId,
        type: "REFRESH",
        revokedAt: null,
        expiresAt: { gt: new Date() },
      },
      orderBy: { lastActiveAt: "desc" },
    });
  }

  /**
   * Find session by ID.
   */
  async findById(id: string): Promise<RefreshToken | null> {
    return prisma.refreshToken.findUnique({
      where: { id },
    });
  }

  /**
   * Revoke a single session record.
   */
  async revoke(id: string, reason: string): Promise<RefreshToken> {
    return prisma.refreshToken.update({
      where: { id },
      data: {
        revokedAt: new Date(),
        revokeReason: reason,
      },
    });
  }

  /**
   * Revoke all active sessions for a user, optionally keeping the current one active.
   */
  async revokeAllByUserId(
    userId: string,
    reason: string,
    excludeId?: string
  ): Promise<number> {
    const whereClause: any = {
      userId,
      revokedAt: null,
    };

    if (excludeId) {
      whereClause.id = { not: excludeId };
    }

    const result = await prisma.refreshToken.updateMany({
      where: whereClause,
      data: {
        revokedAt: new Date(),
        revokeReason: reason,
      },
    });

    return result.count;
  }

  /**
   * Mark token as replaced by successor in token rotation chain.
   */
  async updateRotation(id: string, replacedByTokenId: string): Promise<void> {
    await prisma.refreshToken.update({
      where: { id },
      data: {
        revokedAt: new Date(),
        revokeReason: "token_rotated",
        replacedByTokenId,
        lastActiveAt: new Date(),
      },
    });
  }

  /**
   * Update last active timestamp.
   */
  async updateLastActive(id: string): Promise<void> {
    await prisma.refreshToken.update({
      where: { id },
      data: { lastActiveAt: new Date() },
    });
  }
}

export const refreshTokenRepo = new RefreshTokenRepo();
