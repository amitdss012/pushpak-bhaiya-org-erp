import type { Request, Response } from "express";
import { asyncHandler } from "../../../middlewares/error.middleware.js";
import { statusCode } from "../../../types/types.js";
import { SuccessResponse } from "../../../utils/response.util.js";
import { organizationService } from "../services/organization.service.js";
import { uuidParamSchema } from "../validators/common.validator.js";
import {
  onboardOrganizationSchema,
  orgQuerySchema,
  updateOrganizationSchema,
  updateOrgSubscriptionSchema,
} from "../validators/organization.validator.js";

/**
 * Controller for onboarding a new organization with initial plan & owner user.
 * POST /api/v1/platform/organizations/onboard
 */
export const onboardOrganization = asyncHandler(async (req: Request, res: Response) => {
  const validatedData = await onboardOrganizationSchema.parseAsync(req.body);
  const result = await organizationService.onboardOrganization(validatedData);
  return SuccessResponse(
    res,
    "Organization onboarded successfully with subscription plan and owner account",
    result,
    statusCode.Created
  );
});

/**
 * Controller for retrieving paginated organizations.
 * GET /api/v1/platform/organizations
 */
export const getAllOrganizations = asyncHandler(async (req: Request, res: Response) => {
  const validatedQuery = await orgQuerySchema.parseAsync(req.query);
  const result = await organizationService.getAllOrganizations(validatedQuery);
  return SuccessResponse(
    res,
    "Organizations retrieved successfully",
    result,
    statusCode.OK
  );
});

/**
 * Controller for retrieving detailed organization profile by ID.
 * GET /api/v1/platform/organizations/:id
 */
export const getOrganizationById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = await uuidParamSchema.parseAsync(req.params);
  const org = await organizationService.getOrganizationById(id);
  return SuccessResponse(
    res,
    "Organization details retrieved successfully",
    org,
    statusCode.OK
  );
});

/**
 * Controller for updating organization profile.
 * PATCH /api/v1/platform/organizations/:id
 */
export const updateOrganization = asyncHandler(async (req: Request, res: Response) => {
  const { id } = await uuidParamSchema.parseAsync(req.params);
  const validatedData = await updateOrganizationSchema.parseAsync(req.body);
  const updatedOrg = await organizationService.updateOrganization(id, validatedData);
  return SuccessResponse(
    res,
    "Organization updated successfully",
    updatedOrg,
    statusCode.OK
  );
});

/**
 * Controller for updating organization subscription plan and status.
 * PATCH /api/v1/platform/organizations/:id/subscription
 */
export const updateOrgSubscription = asyncHandler(async (req: Request, res: Response) => {
  const { id } = await uuidParamSchema.parseAsync(req.params);
  const validatedData = await updateOrgSubscriptionSchema.parseAsync(req.body);
  const updatedSub = await organizationService.updateOrgSubscription(id, validatedData);
  return SuccessResponse(
    res,
    "Organization subscription updated successfully",
    updatedSub,
    statusCode.OK
  );
});