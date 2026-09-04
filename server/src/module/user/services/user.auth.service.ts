import type { Request } from "express";
import { statusCode, type DeviceType } from "../../../types/types.js";
import {
  generateRandomToken,
  generateToken,
  hashToken,
} from "../../../utils/jwt.js";
import { comparePassword } from "../../../utils/password.js";
import { ErrorResponse } from "../../../utils/response.util.js";
import { auditLogRepo, type AuditLogRepo } from "../repos/audit-log.repo.js";
import { refreshTokenRepo, type RefreshTokenRepo } from "../repos/refresh-token.repo.js";
import { userRepo, type UserRepo } from "../repos/user.repo.js";
import type {
  DeviceSessionInfo,
  SanitizedUserWithDetails,
  UserTokenPayload,
} from "../types/user.types.js";
import type { RefreshTokenInput, UserLoginInput } from "../validators/user.validator.js";

export class UserAuthService {
  constructor(
    private readonly users: UserRepo = userRepo,
    private readonly sessions: RefreshTokenRepo = refreshTokenRepo,
    private readonly auditLogs: AuditLogRepo = auditLogRepo
  ) {}

  /**
   * Parse device and network metadata from HTTP request.
   */
  private extractDeviceInfo(req: Request, input?: Partial<UserLoginInput>): DeviceSessionInfo {
    const rawUserAgent = req.headers["user-agent"] || "";
    const forwardedFor = req.headers["x-forwarded-for"] as string | undefined;
    const ipAddress = forwardedFor ? forwardedFor.split(",")[0]?.trim() : req.ip || "127.0.0.1";

    let browser = "Unknown Browser";
    let os = "Unknown OS";
    let deviceType: DeviceType = input?.deviceType || "UNKNOWN";

    // Simple heuristic parser for User-Agent
    if (/mobile/i.test(rawUserAgent)) {
      deviceType = "MOBILE";
    } else if (/tablet|ipad/i.test(rawUserAgent)) {
      deviceType = "TABLET";
    } else if (/windows|macintosh|linux/i.test(rawUserAgent)) {
      deviceType = "DESKTOP";
    }

    if (/chrome|crios/i.test(rawUserAgent)) browser = "Chrome";
    else if (/firefox|fxios/i.test(rawUserAgent)) browser = "Firefox";
    else if (/safari/i.test(rawUserAgent)) browser = "Safari";
    else if (/edg/i.test(rawUserAgent)) browser = "Edge";

    if (/windows/i.test(rawUserAgent)) os = "Windows";
    else if (/mac os/i.test(rawUserAgent)) os = "macOS";
    else if (/android/i.test(rawUserAgent)) os = "Android";
    else if (/iphone|ipad|ipod/i.test(rawUserAgent)) os = "iOS";
    else if (/linux/i.test(rawUserAgent)) os = "Linux";

    return {
      deviceId: input?.deviceId || undefined,
      deviceType,
      deviceName: input?.deviceName || `${browser} on ${os}`,
      browser,
      os,
      ipAddress,
      userAgent: rawUserAgent,
    };
  }

  /**
   * Generate short-lived JWT Access Token.
   */
  private generateAccessToken(payload: UserTokenPayload): string {
    return generateToken(payload, "15m");
  }

  /**
   * Authenticate user, issue tokens, and register device session.
   */
  async login(
    input: UserLoginInput,
    req: Request
  ): Promise<{
    user: SanitizedUserWithDetails;
    accessToken: string;
    refreshToken: string;
    sessionId: string;
  }> {
    const user = await this.users.findByEmail(input.email, input.organizationId);

    if (!user) {
      throw new ErrorResponse("Invalid email or password", statusCode.Unauthorized);
    }

    if (user.status !== "ACTIVE") {
      throw new ErrorResponse(
        `Account status is ${user.status}. Please contact your administrator.`,
        statusCode.Forbidden
      );
    }

    const isPasswordValid = await comparePassword(input.password, user.passwordHash);
    if (!isPasswordValid) {
      // Record failed login attempt for audit
      await this.auditLogs.create({
        organizationId: user.organizationId,
        branchId: user.branchId,
        userId: user.id,
        action: "LOGIN_FAILED",
        ipAddress: req.ip,
        userAgent: req.headers["user-agent"],
        metadata: { reason: "invalid_password" },
      });

      throw new ErrorResponse("Invalid email or password", statusCode.Unauthorized);
    }

    // Generate token pair
    const tokenPayload: UserTokenPayload = {
      id: user.id,
      organizationId: user.organizationId,
      branchId: user.branchId,
      scope: user.scope,
      email: user.email,
    };

    const accessToken = this.generateAccessToken(tokenPayload);
    const rawRefreshToken = generateRandomToken();
    const refreshTokenHash = hashToken(rawRefreshToken);
    const accessTokenHash = hashToken(accessToken);

    // Refresh token expiry (30 days)
    const expiresAt = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);
    const deviceInfo = this.extractDeviceInfo(req, input);

    // Create session
    const session = await this.sessions.create({
      userId: user.id,
      refreshTokenHash,
      accessTokenHash,
      expiresAt,
      deviceId: deviceInfo.deviceId,
      deviceType: deviceInfo.deviceType,
      deviceName: deviceInfo.deviceName,
      browser: deviceInfo.browser,
      os: deviceInfo.os,
      ipAddress: deviceInfo.ipAddress,
      userAgent: deviceInfo.userAgent,
    });

    // Update last login
    await this.users.updateLastLogin(user.id);

    // Immutable audit log
    await this.auditLogs.create({
      organizationId: user.organizationId,
      branchId: user.branchId,
      userId: user.id,
      action: "LOGIN",
      ipAddress: deviceInfo.ipAddress,
      userAgent: deviceInfo.userAgent,
      metadata: { sessionId: session.id, deviceName: deviceInfo.deviceName },
    });

    // Fetch eager loaded profile with roles, branch, org, student/teacher/parent
    const detailedUser = await this.users.findByIdWithDetails(user.id);
    const { passwordHash: _passwordHash, ...sanitized } = detailedUser!;

    return {
      user: sanitized as unknown as SanitizedUserWithDetails,
      accessToken,
      refreshToken: rawRefreshToken,
      sessionId: session.id,
    };
  }

  /**
   * Rotate Refresh Token with Replay Attack Detection (RFC 6749 standard).
   */
  async refreshToken(
    input: RefreshTokenInput,
    req: Request
  ): Promise<{
    accessToken: string;
    refreshToken: string;
    sessionId: string;
  }> {
    const incomingTokenHash = hashToken(input.refreshToken);
    const existingSession = await this.sessions.findByTokenHash(incomingTokenHash);

    if (!existingSession) {
      throw new ErrorResponse(
        "Invalid or unrecognized refresh token",
        statusCode.Unauthorized
      );
    }

    // Replay attack detection: If token was already revoked, invalidate family
    if (existingSession.revokedAt) {
      await this.sessions.revokeAllByUserId(
        existingSession.userId,
        "token_reuse_detected"
      );

      throw new ErrorResponse(
        "Session compromised. Token reuse detected. Please log in again.",
        statusCode.Unauthorized
      );
    }

    // Check expiration
    if (existingSession.expiresAt < new Date()) {
      await this.sessions.revoke(existingSession.id, "expired");
      throw new ErrorResponse(
        "Session has expired. Please log in again.",
        statusCode.Unauthorized
      );
    }

    const user = await this.users.findById(existingSession.userId);
    if (!user || user.status !== "ACTIVE") {
      throw new ErrorResponse(
        "User account is no longer active",
        statusCode.Unauthorized
      );
    }

    // Issue new pair
    const tokenPayload: UserTokenPayload = {
      id: user.id,
      organizationId: user.organizationId,
      branchId: user.branchId,
      scope: user.scope,
      email: user.email,
    };

    const newAccessToken = this.generateAccessToken(tokenPayload);
    const newRawRefreshToken = generateRandomToken();
    const newRefreshTokenHash = hashToken(newRawRefreshToken);
    const newAccessTokenHash = hashToken(newAccessToken);

    const expiresAt = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);
    const deviceInfo = this.extractDeviceInfo(req);

    // Create successor session record
    const newSession = await this.sessions.create({
      userId: user.id,
      refreshTokenHash: newRefreshTokenHash,
      accessTokenHash: newAccessTokenHash,
      expiresAt,
      deviceId: existingSession.deviceId || deviceInfo.deviceId,
      deviceType: existingSession.deviceType,
      deviceName: existingSession.deviceName,
      browser: deviceInfo.browser,
      os: deviceInfo.os,
      ipAddress: deviceInfo.ipAddress,
      userAgent: deviceInfo.userAgent,
    });

    // Mark previous token as replaced
    await this.sessions.updateRotation(existingSession.id, newSession.id);

    return {
      accessToken: newAccessToken,
      refreshToken: newRawRefreshToken,
      sessionId: newSession.id,
    };
  }

  /**
   * Log out current device session.
   */
  async logout(
    user: SanitizedUserWithDetails,
    sessionId?: string,
    req?: Request
  ): Promise<{ message: string }> {
    if (sessionId) {
      await this.sessions.revoke(sessionId, "manual_logout");
    }

    await this.auditLogs.create({
      organizationId: user.organizationId,
      branchId: user.branchId,
      userId: user.id,
      action: "LOGOUT",
      ipAddress: req?.ip,
      userAgent: req?.headers["user-agent"],
      metadata: { sessionId },
    });

    return { message: "Logged out successfully" };
  }

  /**
   * Log out all active device sessions for user.
   */
  async logoutAll(
    user: SanitizedUserWithDetails,
    req?: Request
  ): Promise<{ message: string; sessionsRevoked: number }> {
    const count = await this.sessions.revokeAllByUserId(
      user.id,
      "logout_all_devices"
    );

    await this.auditLogs.create({
      organizationId: user.organizationId,
      branchId: user.branchId,
      userId: user.id,
      action: "LOGOUT",
      ipAddress: req?.ip,
      userAgent: req?.headers["user-agent"],
      metadata: { scope: "all_devices", count },
    });

    return {
      message: "All device sessions have been terminated",
      sessionsRevoked: count,
    };
  }
}

export const userAuthService = new UserAuthService();
