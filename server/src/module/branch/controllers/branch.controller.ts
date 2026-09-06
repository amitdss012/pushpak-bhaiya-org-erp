import type { Request, Response } from "express";
import type { StorageFile } from "../../../lib/storage/storage.interface.js";
import { asyncHandler } from "../../../middlewares/error.middleware.js";
import { statusCode } from "../../../types/types.js";
import { SuccessResponse } from "../../../utils/response.util.js";
import { branchService } from "../services/branch.service.js";
import {
  createBranchValidator,
  listBranchesValidator,
} from "../validators/branch.validator.js";

/**
 * POST /api/v1/branch
 * Create a new Branch with optional Cloudinary logo upload.
 */
export const createBranch = asyncHandler(async (req: Request, res: Response) => {
  const validatedInput = createBranchValidator.parse(req.body);

  let logoFile: StorageFile | undefined;
  if (req.file) {
    logoFile = {
      buffer: req.file.buffer,
      originalname: req.file.originalname,
      mimetype: req.file.mimetype,
      size: req.file.size,
    };
  }

  const newBranch = await branchService.createBranch(
    req.user!,
    validatedInput,
    logoFile,
    req
  );

  return SuccessResponse(
    res,
    "Branch created successfully",
    newBranch,
    statusCode.Created
  );
});

/**
 * GET /api/v1/branch
 * View all branches (paginated, with search filters and KPI metrics).
 */
export const listBranches = asyncHandler(async (req: Request, res: Response) => {
  const query = listBranchesValidator.parse(req.query);
  const result = await branchService.listBranches(req.user!, query);

  return SuccessResponse(
    res,
    "Branches retrieved successfully",
    result,
    statusCode.OK
  );
});
