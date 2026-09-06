import { Router } from "express";
import { uploadLogo } from "../../../middlewares/upload.middleware.js";
import { PermissionKey } from "../../../types/types.js";
import {
  requirePermission,
  userAuthMiddleware,
} from "../../user/middlewares/user.auth.middleware.js";
import {
  createBranch,
  listBranches,
} from "../controllers/branch.controller.js";

const branchRouter: Router = Router();

// Authentication required for all branch routes
branchRouter.use(userAuthMiddleware);

/**
 * @route   POST /api/v1/branch
 * @desc    Create a new branch with optional Cloudinary logo upload
 * @access  Protected (CREATE_BRANCH)
 */
branchRouter.post(
  "/",
  requirePermission(PermissionKey.CREATE_BRANCH),
  uploadLogo.single("logo"),
  createBranch
);

/**
 * @route   GET /api/v1/branch
 * @desc    View all branches (paginated, search filters, and KPI summary stats)
 * @access  Protected (READ_BRANCH)
 */
branchRouter.get(
  "/",
  requirePermission(PermissionKey.READ_BRANCH),
  listBranches
);

export { branchRouter };
