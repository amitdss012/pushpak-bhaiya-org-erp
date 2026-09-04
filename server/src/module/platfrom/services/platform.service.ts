import type { PlatformAdmin } from "../../../types/types.js";
import type {
  PlatformAdminTokenPayload,
  SanitizedPlatformAdmin,
} from "../types/platform.types.js";
import { statusCode } from "../../../types/types.js";
import { generateToken } from "../../../utils/jwt.js";
import { comparePassword } from "../../../utils/password.js";
import { ErrorResponse } from "../../../utils/response.util.js";
import { platformRepo, type PlatformRepo } from "../repos/platform.repo.js";
import type { PlatformLoginInput } from "../validators/platform.validator.js";

export class PlatformService {
  constructor(private readonly repo: PlatformRepo = platformRepo) {}

  /**
   * Helper to strip sensitive information from platform admin entity.
   */
  private sanitizeAdmin(admin: PlatformAdmin): SanitizedPlatformAdmin {
    const { passwordHash: _passwordHash, ...sanitized } = admin;
    return sanitized;
  }

  /**
   * Generate JWT Access Token for Platform Admin.
   */
  private generateToken(admin: PlatformAdmin): string {
    const payload: PlatformAdminTokenPayload = {
      id: admin.id,
      email: admin.email,
      role: "PLATFORM_ADMIN",
    };

    return generateToken(payload, "7d");
  }

  /**
   * Authenticate platform admin and issue JWT token.
   */
  async login(input: PlatformLoginInput): Promise<{
    admin: SanitizedPlatformAdmin;
    token: string;
  }> {
    const admin = await this.repo.findByEmail(input.email);
    if (!admin) {
      throw new ErrorResponse(
        "Invalid email or password",
        statusCode.Unauthorized
      );
    }

    if (!admin.isActive) {
      throw new ErrorResponse(
        "Account is deactivated. Please contact support.",
        statusCode.Forbidden
      );
    }

    const isPasswordValid = await comparePassword(
      input.password,
      admin.passwordHash
    );

    if (!isPasswordValid) {
      throw new ErrorResponse(
        "Invalid email or password",
        statusCode.Unauthorized
      );
    }

    // Update last login timestamp asynchronously
    await this.repo.updateLastLogin(admin.id);

    const token = this.generateToken(admin);
    const sanitizedAdmin = this.sanitizeAdmin(admin);

    return {
      admin: sanitizedAdmin,
      token,
    };
  }

  /**
   * Fetch authenticated platform admin profile by ID.
   */
  async getProfile(adminId: string): Promise<SanitizedPlatformAdmin> {
    const admin = await this.repo.findById(adminId);
    if (!admin) {
      throw new ErrorResponse(
        "Platform admin not found",
        statusCode.Not_Found
      );
    }

    if (!admin.isActive) {
      throw new ErrorResponse(
        "Account is deactivated",
        statusCode.Forbidden
      );
    }

    return this.sanitizeAdmin(admin);
  }

  /**
   * Perform logout operation for platform admin.
   */
  async logout(): Promise<{ message: string }> {
    return {
      message: "Platform admin logged out successfully",
    };
  }
}

export const platformService = new PlatformService();
