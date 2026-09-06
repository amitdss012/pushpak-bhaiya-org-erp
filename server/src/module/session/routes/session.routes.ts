import { Router } from "express";
import { PermissionKey } from "../../../types/types.js";
import {
  userAuthMiddleware,
  requirePermission,
} from "../../user/middlewares/user.auth.middleware.js";
import {
  createSession,
  deleteSession,
  getCurrentSession,
  getSessionById,
  listSessions,
  mapBranchesToSession,
  setBranchCurrentSession,
  updateSession,
} from "../controllers/session.controller.js";

const sessionRouter: Router = Router();

// Authentication required for all session routes
sessionRouter.use(userAuthMiddleware);

/**
 * @route   GET /api/v1/session
 * @desc    List paginated academic sessions
 * @access  Protected
 */
sessionRouter.get(
  "/",
  requirePermission(PermissionKey.MANAGE_ACADEMIC_YEAR),
  listSessions
);

/**
 * @route   GET /api/v1/session/current
 * @desc    Get active session for caller's branch or query branchId
 * @access  Protected
 */
sessionRouter.get("/current", getCurrentSession);

/**
 * @route   POST /api/v1/session/set-current
 * @desc    Set the active academic session for a branch
 * @access  Protected (MANAGE_ACADEMIC_YEAR)
 */
sessionRouter.post(
  "/set-current",
  requirePermission(PermissionKey.MANAGE_ACADEMIC_YEAR),
  setBranchCurrentSession
);

/**
 * @route   GET /api/v1/session/:id
 * @desc    Get master academic session by ID
 * @access  Protected
 */
sessionRouter.get(
  "/:id",
  requirePermission(PermissionKey.MANAGE_ACADEMIC_YEAR),
  getSessionById
);

/**
 * @route   POST /api/v1/session
 * @desc    Create master academic session and map to branch(es)
 * @access  Protected (MANAGE_ACADEMIC_YEAR)
 */
sessionRouter.post(
  "/",
  requirePermission(PermissionKey.MANAGE_ACADEMIC_YEAR),
  createSession
);

/**
 * @route   PATCH /api/v1/session/:id
 * @desc    Update master academic session metadata
 * @access  Protected (MANAGE_ACADEMIC_YEAR)
 */
sessionRouter.patch(
  "/:id",
  requirePermission(PermissionKey.MANAGE_ACADEMIC_YEAR),
  updateSession
);

/**
 * @route   POST /api/v1/session/:id/branches
 * @desc    Map branches to an academic session
 * @access  Protected (MANAGE_ACADEMIC_YEAR)
 */
sessionRouter.post(
  "/:id/branches",
  requirePermission(PermissionKey.MANAGE_ACADEMIC_YEAR),
  mapBranchesToSession
);

/**
 * @route   DELETE /api/v1/session/:id
 * @desc    Soft-delete an academic session
 * @access  Protected (MANAGE_ACADEMIC_YEAR)
 */
sessionRouter.delete(
  "/:id",
  requirePermission(PermissionKey.MANAGE_ACADEMIC_YEAR),
  deleteSession
);

export { sessionRouter };
