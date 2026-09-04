import type { Request } from "express";
import { statusCode } from "../../../types/types.js";
import { ErrorResponse } from "../../../utils/response.util.js";
import { auditLogRepo, type AuditLogRepo } from "../repos/audit-log.repo.js";
import { userRepo, type UserRepo } from "../repos/user.repo.js";
import type { SanitizedUserWithDetails } from "../types/user.types.js";
import type { UpdateAvatarInput, UpdateProfileInput } from "../validators/user.validator.js";

export class UserProfileService {
  constructor(
    private readonly users: UserRepo = userRepo,
    private readonly auditLogs: AuditLogRepo = auditLogRepo
  ) {}

  /**
   * Retrieve full sanitized user profile with populated relations and persona links.
   */
  async getProfile(userId: string): Promise<SanitizedUserWithDetails> {
    const user = await this.users.findByIdWithDetails(userId);
    if (!user) {
      throw new ErrorResponse("User not found", statusCode.Not_Found);
    }

    if (user.status !== "ACTIVE") {
      throw new ErrorResponse("User account is deactivated", statusCode.Forbidden);
    }

    const { passwordHash: _passwordHash, ...sanitized } = user;
    return sanitized as unknown as SanitizedUserWithDetails;
  }

  /**
   * Update personal profile information.
   */
  async updateProfile(
    userId: string,
    input: UpdateProfileInput,
    req?: Request
  ): Promise<SanitizedUserWithDetails> {
    const existing = await this.users.findById(userId);
    if (!existing) {
      throw new ErrorResponse("User not found", statusCode.Not_Found);
    }

    const updated = await this.users.updateProfile(userId, {
      firstName: input.firstName,
      lastName: input.lastName,
      phone: input.phone,
    });

    // Record audit
    await this.auditLogs.create({
      organizationId: existing.organizationId,
      branchId: existing.branchId,
      userId: existing.id,
      action: "USER_UPDATED",
      targetEntity: "User",
      targetEntityId: existing.id,
      ipAddress: req?.ip,
      userAgent: req?.headers["user-agent"],
      metadata: {
        oldValues: { firstName: existing.firstName, lastName: existing.lastName, phone: existing.phone },
        newValues: input,
      },
    });

    return this.getProfile(updated.id);
  }

  /**
   * Update avatar image URL.
   */
  async updateAvatar(
    userId: string,
    input: UpdateAvatarInput,
    req?: Request
  ): Promise<SanitizedUserWithDetails> {
    const existing = await this.users.findById(userId);
    if (!existing) {
      throw new ErrorResponse("User not found", statusCode.Not_Found);
    }

    const updated = await this.users.updateProfile(userId, {
      avatar: input.avatar,
    });

    await this.auditLogs.create({
      organizationId: existing.organizationId,
      branchId: existing.branchId,
      userId: existing.id,
      action: "USER_UPDATED",
      targetEntity: "User",
      targetEntityId: existing.id,
      ipAddress: req?.ip,
      userAgent: req?.headers["user-agent"],
      metadata: { updatedField: "avatar" },
    });

    return this.getProfile(updated.id);
  }
}

export const userProfileService = new UserProfileService();
