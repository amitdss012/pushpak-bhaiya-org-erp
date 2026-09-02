import type { Request, Response } from "express";
import { asyncHandler } from "../../../middlewares/error.middleware.js";
import { statusCode } from "../../../types/types.js";
import { SuccessResponse } from "../../../utils/response.util.js";
import { planService } from "../services/plan.service.js";
import { uuidParamSchema } from "../validators/common.validator.js";
import {
  createPlanSchema,
  planQuerySchema,
  updatePlanSchema,
} from "../validators/plan.validator.js";

/**
 * Controller for creating a subscription plan.
 * POST /api/v1/platform/plans
 */
export const createPlan = asyncHandler(async (req: Request, res: Response) => {
  const validatedData = await createPlanSchema.parseAsync(req.body);
  const plan = await planService.createPlan(validatedData);
  return SuccessResponse(
    res,
    "Subscription plan created successfully",
    plan,
    statusCode.Created
  );
});

/**
 * Controller for retrieving all subscription plans.
 * GET /api/v1/platform/plans
 */
export const getAllPlans = asyncHandler(async (req: Request, res: Response) => {
  const validatedQuery = await planQuerySchema.parseAsync(req.query);
  const plans = await planService.getAllPlans(validatedQuery);
  return SuccessResponse(
    res,
    "Subscription plans retrieved successfully",
    plans,
    statusCode.OK
  );
});

/**
 * Controller for retrieving a single subscription plan by ID.
 * GET /api/v1/platform/plans/:id
 */
export const getPlanById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = await uuidParamSchema.parseAsync(req.params);
  const plan = await planService.getPlanById(id);
  return SuccessResponse(
    res,
    "Subscription plan retrieved successfully",
    plan,
    statusCode.OK
  );
});

/**
 * Controller for updating a subscription plan.
 * PATCH /api/v1/platform/plans/:id
 */
export const updatePlan = asyncHandler(async (req: Request, res: Response) => {
  const { id } = await uuidParamSchema.parseAsync(req.params);
  const validatedData = await updatePlanSchema.parseAsync(req.body);
  const plan = await planService.updatePlan(id, validatedData);
  return SuccessResponse(
    res,
    "Subscription plan updated successfully",
    plan,
    statusCode.OK
  );
});

/**
 * Controller for deleting a subscription plan.
 * DELETE /api/v1/platform/plans/:id
 */
export const deletePlan = asyncHandler(async (req: Request, res: Response) => {
  const { id } = await uuidParamSchema.parseAsync(req.params);
  const result = await planService.deletePlan(id);
  return SuccessResponse(res, result.message, {}, statusCode.OK);
});
