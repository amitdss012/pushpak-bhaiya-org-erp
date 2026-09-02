import { Router } from "express";
import {
  getAllOrganizations,
  getOrganizationById,
  onboardOrganization,
  updateOrganization,
  updateOrgSubscription,
} from "../controllers/organization.controller.js";
import {
  createPlan,
  deletePlan,
  getAllPlans,
  getPlanById,
  updatePlan,
} from "../controllers/plan.controller.js";
import {
  getPlatformProfile,
  platformLogin,
  platformLogout,
} from "../controllers/platform.controller.js";
import { platformAuthMiddleware } from "../middlewares/platform.auth.middleware.js";

const platformRouter: Router = Router();

/* ==========================================================================
   Platform Admin Authentication Routes
   ========================================================================== */

/**
 * @route   POST /api/v1/platform/login
 * @desc    Authenticate platform admin and issue JWT token
 * @access  Public
 */
platformRouter.post("/login", platformLogin);

/**
 * @route   GET /api/v1/platform/profile
 * @desc    Retrieve authenticated platform admin profile
 * @access  Protected (Platform Admin)
 */
platformRouter.get("/profile", platformAuthMiddleware, getPlatformProfile);

/**
 * @route   POST /api/v1/platform/logout
 * @desc    Logout platform admin session
 * @access  Protected (Platform Admin)
 */
platformRouter.post("/logout", platformAuthMiddleware, platformLogout);

/* ==========================================================================
   Subscription Plans Management Routes
   ========================================================================== */

/**
 * @route   POST /api/v1/platform/plans
 * @desc    Create a new subscription plan
 * @access  Protected (Platform Admin)
 */
platformRouter.post("/plans", platformAuthMiddleware, createPlan);

/**
 * @route   GET /api/v1/platform/plans
 * @desc    List all subscription plans (ordered by sortOrder)
 * @access  Protected (Platform Admin)
 */
platformRouter.get("/plans", platformAuthMiddleware, getAllPlans);

/**
 * @route   GET /api/v1/platform/plans/:id
 * @desc    Get subscription plan details by ID
 * @access  Protected (Platform Admin)
 */
platformRouter.get("/plans/:id", platformAuthMiddleware, getPlanById);

/**
 * @route   PATCH /api/v1/platform/plans/:id
 * @desc    Update an existing subscription plan
 * @access  Protected (Platform Admin)
 */
platformRouter.patch("/plans/:id", platformAuthMiddleware, updatePlan);

/**
 * @route   DELETE /api/v1/platform/plans/:id
 * @desc    Delete a subscription plan (if no active subscribers)
 * @access  Protected (Platform Admin)
 */
platformRouter.delete("/plans/:id", platformAuthMiddleware, deletePlan);

/* ==========================================================================
   Organization Onboarding & Management Routes
   ========================================================================== */

/**
 * @route   POST /api/v1/platform/organizations/onboard
 * @desc    Onboard an organization with initial plan & owner user
 * @access  Protected (Platform Admin)
 */
platformRouter.post(
  "/organizations/onboard",
  platformAuthMiddleware,
  onboardOrganization
);

/**
 * @route   GET /api/v1/platform/organizations
 * @desc    List all organizations with search, status filter, and pagination
 * @access  Protected (Platform Admin)
 */
platformRouter.get("/organizations", platformAuthMiddleware, getAllOrganizations);

/**
 * @route   GET /api/v1/platform/organizations/:id
 * @desc    Get detailed organization profile by ID
 * @access  Protected (Platform Admin)
 */
platformRouter.get(
  "/organizations/:id",
  platformAuthMiddleware,
  getOrganizationById
);

/**
 * @route   PATCH /api/v1/platform/organizations/:id
 * @desc    Update organization profile and status
 * @access  Protected (Platform Admin)
 */
platformRouter.patch(
  "/organizations/:id",
  platformAuthMiddleware,
  updateOrganization
);

/**
 * @route   PATCH /api/v1/platform/organizations/:id/subscription
 * @desc    Update or upgrade organization's subscription plan & status
 * @access  Protected (Platform Admin)
 */
platformRouter.patch(
  "/organizations/:id/subscription",
  platformAuthMiddleware,
  updateOrgSubscription
);

export { platformRouter };
export default platformRouter;
