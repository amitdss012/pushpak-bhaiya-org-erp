import type { Request } from "express";
import { statusCode } from "../../../types/types.js";
import { generateRandomToken, hashToken } from "../../../utils/jwt.js";
import { comparePassword, hashPassword } from "../../../utils/password.js";
import { ErrorResponse } from "../../../utils/response.util.js";
import { auditLogRepo, type AuditLogRepo } from "../repos/audit-log.repo.js";
import { refreshTokenRepo, type RefreshTokenRepo } from "../repos/refresh-token.repo.js";
import { userRepo, type UserRepo } from "../repos/user.repo.js";
import type {
  ChangePasswordInput,
  ForgotPasswordInput,
  ResetPasswordInput,
} from "../validators/user.validator.js";

export class UserSecurityService {
  constructor(
    private readonly users: UserRepo = userRepo,
    private readonly sessions: RefreshTokenRepo = refreshTokenRepo,
    private readonly auditLogs: AuditLogRepo = auditLogRepo
  ) {}

  /**
   * Change password for authenticated user.
   */
  async changePassword(
    userId: string,
    input: ChangePasswordInput,
    currentSessionId?: string,
    req?: Request
  ): Promise<{ message: string }> {
    const user = await this.users.findById(userId);
    if (!user) {
      throw new ErrorResponse("User not found", statusCode.Not_Found);
    }

    const isMatch = await comparePassword(input.currentPassword, user.passwordHash);
    if (!isMatch) {
      throw new ErrorResponse("Current password is incorrect", statusCode.Bad_Request);
    }

    const newHash = await hashPassword(input.newPassword);

    await this.users.updatePassword(user.id, newHash);

    // Invalidate all OTHER device sessions for security
    await this.sessions.revokeAllByUserId(user.id, "password_change", currentSessionId);

    // Record audit
    await this.auditLogs.create({
      organizationId: user.organizationId,
      branchId: user.branchId,
      userId: user.id,
      action: "PASSWORD_CHANGE",
      targetEntity: "User",
      targetEntityId: user.id,
      ipAddress: req?.ip,
      userAgent: req?.headers["user-agent"],
    });

    return { message: "Password updated successfully. Other device sessions invalidated." };
  }

  /**
   * Request password reset token.
   */
  async forgotPassword(
    input: ForgotPasswordInput,
    req?: Request
  ): Promise<{ message: string; resetToken?: string }> {
    const user = await this.users.findByEmail(input.email, input.organizationId);

    // For security, do not leak whether email exists
    if (!user || user.status !== "ACTIVE") {
      return {
        message: "If an active account exists with that email, a password reset token has been generated.",
      };
    }

    // Generate random reset token (valid for 1 hour)
    const rawResetToken = generateRandomToken(32);
    const tokenHash = hashToken(rawResetToken);
    const expiresAt = new Date(Date.now() + 60 * 60 * 1000); // 1 hour

    await this.sessions.create({
      userId: user.id,
      refreshTokenHash: tokenHash,
      type: "PASSWORD_RESET",
      expiresAt,
      ipAddress: req?.ip,
      userAgent: req?.headers["user-agent"],
    });

    await this.auditLogs.create({
      organizationId: user.organizationId,
      branchId: user.branchId,
      userId: user.id,
      action: "PASSWORD_RESET_REQUEST",
      ipAddress: req?.ip,
      userAgent: req?.headers["user-agent"],
    });

    return {
      message: "If an active account exists with that email, a password reset token has been generated.",
      resetToken: rawResetToken, // Provided in response for API integration / notification service
    };
  }

  /**
   * Reset password using reset token.
   */
  async resetPassword(
    input: ResetPasswordInput,
    req?: Request
  ): Promise<{ message: string }> {
    const tokenHash = hashToken(input.token);
    const tokenRecord = await this.sessions.findByTokenHash(tokenHash);

    if (
      !tokenRecord ||
      tokenRecord.type !== "PASSWORD_RESET" ||
      tokenRecord.revokedAt ||
      tokenRecord.expiresAt < new Date()
    ) {
      throw new ErrorResponse(
        "Invalid or expired password reset token",
        statusCode.Bad_Request
      );
    }

    const newHash = await hashPassword(input.newPassword);

    await this.users.updatePassword(tokenRecord.userId, newHash);

    // Revoke the reset token so it cannot be reused
    await this.sessions.revoke(tokenRecord.id, "password_reset_completed");

    // Invalidate all active user sessions everywhere
    await this.sessions.revokeAllByUserId(tokenRecord.userId, "password_reset");

    const user = await this.users.findById(tokenRecord.userId);
    if (user) {
      await this.auditLogs.create({
        organizationId: user.organizationId,
        branchId: user.branchId,
        userId: user.id,
        action: "PASSWORD_CHANGE",
        targetEntity: "User",
        targetEntityId: user.id,
        ipAddress: req?.ip,
        userAgent: req?.headers["user-agent"],
        metadata: { method: "reset_token" },
      });
    }

    return { message: "Password has been successfully reset. Please log in with your new credentials." };
  }
}

export const userSecurityService = new UserSecurityService();
