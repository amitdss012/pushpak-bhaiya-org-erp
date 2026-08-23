import { prisma } from "../../../lib/prisma.js";
import type { PlatformAdmin } from "../../../generated/prisma/client.js";

export class PlatformRepo {
  /**
   * Find a platform admin by email.
   */
  async findByEmail(email: string): Promise<PlatformAdmin | null> {
    return prisma.platformAdmin.findUnique({
      where: { email },
    });
  }

  /**
   * Find a platform admin by primary ID.
   */
  async findById(id: string): Promise<PlatformAdmin | null> {
    return prisma.platformAdmin.findUnique({
      where: { id },
    });
  }

  /**
   * Update the last login timestamp for an admin.
   */
  async updateLastLogin(id: string, lastLoginAt: Date = new Date()): Promise<PlatformAdmin> {
    return prisma.platformAdmin.update({
      where: { id },
      data: { lastLoginAt },
    });
  }
}

export const platformRepo = new PlatformRepo();
