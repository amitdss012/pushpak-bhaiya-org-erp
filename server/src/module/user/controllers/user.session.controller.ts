import type { Request, Response } from "express";
import { asyncHandler } from "../../../middlewares/error.middleware.js";
import { statusCode } from "../../../types/types.js";
import { SuccessResponse } from "../../../utils/response.util.js";
import { userSessionService } from "../services/user.session.service.js";
import { paginationQueryValidator } from "../validators/user.validator.js";

/**
 * @desc    Get all active device sessions for authenticated user
 * @route   GET /api/v1/user/sessions
 * @access  Protected (User)
 */
export const getActiveSessions = asyncHandler(async (req: Request, res: Response) => {
  const sessions = await userSessionService.getActiveSessions(
    req.user!.id,
    req.sessionId
  );

  return SuccessResponse(
    res,
    "Active sessions retrieved successfully",
    sessions,
    statusCode.OK
  );
});

/**
 * @desc    Terminate a specific device session
 * @route   DELETE /api/v1/user/sessions/:sessionId
 * @access  Protected (User)
 */
export const revokeSession = asyncHandler(async (req: Request, res: Response) => {
  const { sessionId } = req.params;
  const result = await userSessionService.revokeSession(
    req.user!.id,
    sessionId as string,
    req
  );

  return SuccessResponse(res, result.message, {}, statusCode.OK);
});

/**
 * @desc    Get paginated security and login audit history for authenticated user
 * @route   GET /api/v1/user/activity-logs
 * @access  Protected (User)
 */
export const getActivityLogs = asyncHandler(async (req: Request, res: Response) => {
  const { page, limit } = paginationQueryValidator.parse(req.query);
  const result = await userSessionService.getActivityLogs(
    req.user!.id,
    page,
    limit
  );

  return SuccessResponse(
    res,
    "Activity logs retrieved successfully",
    result,
    statusCode.OK
  );
});
