import type { Request, Response } from "express";
import { asyncHandler } from "../../../middlewares/error.middleware.js";
import { statusCode } from "../../../types/types.js";
import { SuccessResponse } from "../../../utils/response.util.js";
import { sessionService } from "../services/session.service.js";
import {
  createSessionValidator,
  listSessionsValidator,
  mapBranchesValidator,
  setBranchCurrentSessionValidator,
  updateSessionValidator,
} from "../validators/session.validator.js";

/**
 * POST /api/v1/session
 * Create master Academic Session and map to branch(es).
 */
export const createSession = asyncHandler(
  async (req: Request, res: Response) => {
    const input = createSessionValidator.parse(req.body);
    const session = await sessionService.createSession(
      req.user!,
      input,
      req
    );

    return SuccessResponse(
      res,
      "Academic session created successfully",
      session,
      statusCode.Created
    );
  }
);

/**
 * GET /api/v1/session
 * List paginated academic sessions.
 */
export const listSessions = asyncHandler(
  async (req: Request, res: Response) => {
    const input = listSessionsValidator.parse(req.query);
    const result = await sessionService.listSessions(req.user!, input);

    return SuccessResponse(
      res,
      "Academic sessions retrieved successfully",
      result,
      statusCode.OK
    );
  }
);

/**
 * GET /api/v1/session/current
 * Get current active session for caller's branch or specified branchId.
 */
export const getCurrentSession = asyncHandler(
  async (req: Request, res: Response) => {
    const branchId = req.query.branchId as string | undefined;
    const session = await sessionService.getCurrentSessionForBranch(
      req.user!,
      branchId
    );

    return SuccessResponse(
      res,
      "Current academic session retrieved",
      session,
      statusCode.OK
    );
  }
);

/**
 * GET /api/v1/session/:id
 * Retrieve single academic session details.
 */
export const getSessionById = asyncHandler(
  async (req: Request, res: Response) => {
    const session = await sessionService.getSessionById(
      req.user!,
      req.params.id as string
    );

    return SuccessResponse(
      res,
      "Academic session retrieved",
      session,
      statusCode.OK
    );
  }
);

/**
 * PATCH /api/v1/session/:id
 * Update master academic session metadata.
 */
export const updateSession = asyncHandler(
  async (req: Request, res: Response) => {
    const input = updateSessionValidator.parse(req.body);
    const session = await sessionService.updateSession(
      req.user!,
      req.params.id as string,
      input,
      req
    );

    return SuccessResponse(
      res,
      "Academic session updated successfully",
      session,
      statusCode.OK
    );
  }
);

/**
 * POST /api/v1/session/:id/branches
 * Map branches to an academic session.
 */
export const mapBranchesToSession = asyncHandler(
  async (req: Request, res: Response) => {
    const input = mapBranchesValidator.parse(req.body);
    const session = await sessionService.mapBranches(
      req.user!,
      req.params.id as string,
      input,
      req
    );

    return SuccessResponse(
      res,
      "Branches mapped to session successfully",
      session,
      statusCode.OK
    );
  }
);

/**
 * POST /api/v1/session/set-current
 * Set active/current session for a branch.
 */
export const setBranchCurrentSession = asyncHandler(
  async (req: Request, res: Response) => {
    const input = setBranchCurrentSessionValidator.parse(req.body);
    const updated = await sessionService.setBranchCurrentSession(
      req.user!,
      input,
      req
    );

    return SuccessResponse(
      res,
      "Branch current session updated successfully",
      updated,
      statusCode.OK
    );
  }
);

/**
 * DELETE /api/v1/session/:id
 * Soft-delete an academic session.
 */
export const deleteSession = asyncHandler(
  async (req: Request, res: Response) => {
    await sessionService.deleteSession(
      req.user!,
      req.params.id as string,
      req
    );

    return SuccessResponse(
      res,
      "Academic session deleted successfully",
      null,
      statusCode.OK
    );
  }
);
