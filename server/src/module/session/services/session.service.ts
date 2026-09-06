import type { Request } from "express";
import { statusCode } from "../../../types/types.js";
import { ErrorResponse } from "../../../utils/response.util.js";
import type { SanitizedUserWithDetails } from "../../user/types/user.types.js";
import { sessionRepo, type SessionRepo } from "../repos/session.repo.js";
import type {
  AcademicSessionWithDetails,
  BranchAcademicSessionWithDetails,
  PaginatedSessionsResult,
} from "../types/session.types.js";
import type {
  CreateSessionInput,
  ListSessionsInput,
  MapBranchesInput,
  SetBranchCurrentSessionInput,
  UpdateSessionInput,
} from "../validators/session.validator.js";

export class SessionService {
  constructor(private readonly sessions: SessionRepo = sessionRepo) {}

  /**
   * Create master Academic Session and map to branch(es).
   * - An organization user can specify one or multiple branchIds or none (master only).
   * - A branch user automatically has their branch mapped, and createdById is set to caller.id.
   */
  async createSession(
    caller: SanitizedUserWithDetails,
    input: CreateSessionInput,
    _req?: Request
  ): Promise<AcademicSessionWithDetails> {
    const organizationId = caller.organizationId;

    // Check if name already exists in this organization
    const existing = await this.sessions.findByName(input.name, organizationId);
    if (existing) {
      throw new ErrorResponse(
        `An academic session named '${input.name}' already exists in this organization`,
        statusCode.Conflict
      );
    }

    // Determine target branch mappings
    let targetBranchIds: string[] = [];
    if (caller.branchId) {
      // Branch user can only map their own branch
      targetBranchIds = [caller.branchId];
    } else if (input.branchIds && input.branchIds.length > 0) {
      targetBranchIds = input.branchIds;
    }

    const session = await this.sessions.create(
      {
        organizationId,
        name: input.name,
        code: input.code ?? null,
        startYear: input.startYear,
        endYear: input.endYear,
        startDate: input.startDate,
        endDate: input.endDate,
        description: input.description ?? null,
        createdById: caller.id,
      },
      targetBranchIds,
      input.isCurrentForBranches ?? false
    );

    return session;
  }

  /**
   * List paginated academic sessions with branch filter and keyword search.
   * If caller is a branch-scoped user, results are filtered to their branch.
   */
  async listSessions(
    caller: SanitizedUserWithDetails,
    input: ListSessionsInput
  ): Promise<PaginatedSessionsResult> {
    const organizationId = caller.organizationId;
    const effectiveBranchId = caller.branchId ?? input.branchId;

    return this.sessions.findMany(organizationId, {
      branchId: effectiveBranchId,
      search: input.search,
      page: input.page,
      limit: input.limit,
    });
  }

  /**
   * Retrieve a single academic session by ID.
   */
  async getSessionById(
    caller: SanitizedUserWithDetails,
    id: string
  ): Promise<AcademicSessionWithDetails> {
    const session = await this.sessions.findById(id, caller.organizationId);
    if (!session) {
      throw new ErrorResponse(
        "Academic session not found",
        statusCode.Not_Found
      );
    }

    // If caller is branch-scoped, ensure it is mapped to their branch
    if (caller.branchId) {
      const isMapped = session.branchMappings.some(
        (m) => m.branchId === caller.branchId
      );
      if (!isMapped) {
        throw new ErrorResponse(
          "You do not have access to this academic session",
          statusCode.Forbidden
        );
      }
    }

    return session;
  }

  /**
   * Update master Academic Session metadata.
   */
  async updateSession(
    caller: SanitizedUserWithDetails,
    id: string,
    input: UpdateSessionInput,
    _req?: Request
  ): Promise<AcademicSessionWithDetails> {
    const session = await this.sessions.findById(id, caller.organizationId);
    if (!session) {
      throw new ErrorResponse(
        "Academic session not found",
        statusCode.Not_Found
      );
    }

    if (input.name && input.name !== session.name) {
      const existingName = await this.sessions.findByName(
        input.name,
        caller.organizationId
      );
      if (existingName && existingName.id !== id) {
        throw new ErrorResponse(
          `An academic session named '${input.name}' already exists in this organization`,
          statusCode.Conflict
        );
      }
    }

    const updated = await this.sessions.update(id, caller.organizationId, {
      ...(input.name && { name: input.name }),
      ...(input.code !== undefined && { code: input.code }),
      ...(input.startYear && { startYear: input.startYear }),
      ...(input.endYear && { endYear: input.endYear }),
      ...(input.startDate && { startDate: input.startDate }),
      ...(input.endDate && { endDate: input.endDate }),
      ...(input.description !== undefined && {
        description: input.description,
      }),
    });

    return updated;
  }

  /**
   * Map branches to an Academic Session.
   */
  async mapBranches(
    caller: SanitizedUserWithDetails,
    sessionId: string,
    input: MapBranchesInput,
    _req?: Request
  ): Promise<AcademicSessionWithDetails> {
    const session = await this.sessions.findById(
      sessionId,
      caller.organizationId
    );
    if (!session) {
      throw new ErrorResponse(
        "Academic session not found",
        statusCode.Not_Found
      );
    }

    let targetBranchIds = input.branchIds;
    if (caller.branchId) {
      if (!input.branchIds.includes(caller.branchId)) {
        throw new ErrorResponse(
          "Branch users can only map academic sessions to their own branch",
          statusCode.Forbidden
        );
      }
      targetBranchIds = [caller.branchId];
    }

    await this.sessions.mapBranches(
      sessionId,
      targetBranchIds,
      input.isCurrent ?? false,
      caller.id
    );

    const updatedSession = await this.sessions.findById(
      sessionId,
      caller.organizationId
    );
    return updatedSession!;
  }

  /**
   * Set the active/current academic session for a branch.
   */
  async setBranchCurrentSession(
    caller: SanitizedUserWithDetails,
    input: SetBranchCurrentSessionInput,
    _req?: Request
  ): Promise<BranchAcademicSessionWithDetails> {
    if (caller.branchId && caller.branchId !== input.branchId) {
      throw new ErrorResponse(
        "Branch users can only set the active session for their own branch",
        statusCode.Forbidden
      );
    }

    return this.sessions.setBranchCurrentSession(
      input.branchId,
      input.branchAcademicSessionId
    );
  }

  /**
   * Get the current active academic session for a branch.
   */
  async getCurrentSessionForBranch(
    caller: SanitizedUserWithDetails,
    targetBranchId?: string
  ): Promise<BranchAcademicSessionWithDetails | null> {
    const branchId = caller.branchId ?? targetBranchId;
    if (!branchId) {
      throw new ErrorResponse(
        "Branch ID is required to query active session",
        statusCode.Bad_Request
      );
    }

    const current = await this.sessions.findCurrentSessionForBranch(branchId);
    return current;
  }

  /**
   * Soft-delete an academic session.
   */
  async deleteSession(
    caller: SanitizedUserWithDetails,
    id: string,
    _req?: Request
  ): Promise<void> {
    const session = await this.sessions.findById(id, caller.organizationId);
    if (!session) {
      throw new ErrorResponse(
        "Academic session not found",
        statusCode.Not_Found
      );
    }

    await this.sessions.softDelete(id, caller.organizationId);
  }
}

export const sessionService = new SessionService();
