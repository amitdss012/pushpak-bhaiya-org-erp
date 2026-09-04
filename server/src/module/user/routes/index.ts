import { Router } from "express";
import { userAuthRouter } from "./user.auth.routes.js";
import { userManagementRouter } from "./user.management.routes.js";
import { userProfileRouter } from "./user.profile.routes.js";
import { userPermissionRouter, userRoleRouter } from "./user.role.routes.js";
import { userSecurityRouter } from "./user.security.routes.js";
import { userSessionRouter } from "./user.session.routes.js";

const userRouter: Router = Router();

/* ==========================================================================
   Grouped Sub-Routers
   ========================================================================== */

// 1. Authentication & Token Lifecycle (/api/v1/user/auth/*)
userRouter.use("/auth", userAuthRouter);

// 2. Profile Management (/api/v1/user/profile/*)
userRouter.use("/profile", userProfileRouter);

// 3. Security & Password Lifecycle (/api/v1/user/security/*)
userRouter.use("/security", userSecurityRouter);

// 4. User Management & Provisioning (/api/v1/user/users/*)
userRouter.use("/users", userManagementRouter);

// 5. Role Management & RBAC (/api/v1/user/roles/*)
userRouter.use("/roles", userRoleRouter);

// 6. System Permissions Catalog (/api/v1/user/permissions/*)
userRouter.use("/permissions", userPermissionRouter);

// 7. Device Sessions & Activity Logs (/api/v1/user/sessions, /api/v1/user/activity-logs)
userRouter.use("/", userSessionRouter);


export { userRouter };
