import { Router } from "express";
import {
  getActiveSessions,
  getActivityLogs,
  revokeSession,
} from "../controllers/user.session.controller.js";
import { userAuthMiddleware } from "../middlewares/user.auth.middleware.js";

const userSessionRouter: Router = Router();

// All session and activity routes require authenticated user
userSessionRouter.use(userAuthMiddleware);

/**
 * @route   GET /api/v1/user/sessions
 * @desc    List all active device sessions for authenticated user
 * @access  Protected (User)
 */
userSessionRouter.get("/sessions", getActiveSessions);

/**
 * @route   DELETE /api/v1/user/sessions/:sessionId
 * @desc    Remotely terminate a specific device session
 * @access  Protected (User)
 */
userSessionRouter.delete("/sessions/:sessionId", revokeSession);

/**
 * @route   GET /api/v1/user/activity-logs
 * @desc    Get paginated security and login audit history
 * @access  Protected (User)
 */
userSessionRouter.get("/activity-logs", getActivityLogs);

export { userSessionRouter };
