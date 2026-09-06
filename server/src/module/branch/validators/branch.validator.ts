import { z } from "zod";

/**
 * Validator for creating a new Branch.
 * Supports both JSON body and multipart form fields (using z.coerce).
 */
export const createBranchValidator = z.object({
  // 1. Branch Info
  name: z
    .string({ message: "Branch name is required" })
    .trim()
    .min(2, { message: "Branch name must be at least 2 characters" })
    .max(100, { message: "Branch name cannot exceed 100 characters" }),
  code: z.string().trim().max(50).optional().nullable(),
  branchType: z.string().trim().optional().default("main"),
  instituteType: z.string().trim().optional().default("computer"),
  establishedYear: z.string().trim().max(10).optional().nullable(),
  website: z.string().trim().url().optional().or(z.literal("")).nullable(),
  description: z.string().trim().max(2000).optional().nullable(),
  logo: z.string().trim().url().optional().or(z.literal("")).nullable(),

  // 2. Address Details
  address: z.string().trim().max(500).optional().nullable(),
  streetAddress: z.string().trim().max(500).optional().nullable(),
  city: z.string().trim().max(100).optional().nullable(),
  district: z.string().trim().max(100).optional().nullable(),
  block: z.string().trim().max(100).optional().nullable(),
  state: z.string().trim().max(100).optional().nullable(),
  country: z.string().trim().max(10).optional().default("IN"),
  pincode: z.string().trim().max(20).optional().nullable(),
  latitude: z.coerce.number().optional().nullable(),
  longitude: z.coerce.number().optional().nullable(),

  // 3. Contact Info
  phone: z.string().trim().max(30).optional().nullable(),
  altPhone: z.string().trim().max(30).optional().nullable(),
  whatsapp: z.string().trim().max(30).optional().nullable(),
  email: z.string().trim().email().optional().or(z.literal("")).nullable(),

  // 4. Director Info
  directorName: z.string().trim().max(100).optional().nullable(),
  directorGender: z.string().trim().optional().nullable(),
  directorDob: z.string().trim().optional().nullable(),
  directorBloodGroup: z.string().trim().max(10).optional().nullable(),

  // 5. Space & Facilities
  numComputers: z.coerce.number().int().min(0).optional().default(0),
  numFaculty: z.coerce.number().int().min(0).optional().default(0),
  numRooms: z.coerce.number().int().min(0).optional().default(0),
  numFees: z.coerce.number().min(0).optional().nullable(),
  registrationDate: z.string().trim().optional().nullable(),
  validDate: z.string().trim().optional().nullable(),
  expiryDate: z.string().trim().optional().nullable(),
  renewalDate: z.string().trim().optional().nullable(),
  referralCode: z.string().trim().max(50).optional().nullable(),

  // 6. Settings Switches
  status: z.enum(["ACTIVE", "INACTIVE", "SUSPENDED"]).optional().default("ACTIVE"),
  activeStatus: z.coerce.boolean().optional(),
  onlineEnrollment: z.coerce.boolean().optional().default(true),
  smsNotifications: z.coerce.boolean().optional().default(false),
  emailNotifications: z.coerce.boolean().optional().default(true),

  // 7. Initial Branch Admin Provisioning (Optional)
  adminName: z.string().trim().max(100).optional().nullable(),
  adminUsername: z.string().trim().max(50).optional().nullable(),
  adminPassword: z.string().trim().min(6).max(100).optional().nullable(),
  adminEmail: z.string().trim().email().optional().or(z.literal("")).nullable(),
  adminPhone: z.string().trim().max(30).optional().nullable(),
});

export type CreateBranchInput = z.infer<typeof createBranchValidator>;

/**
 * Validator for querying paginated branches list.
 */
export const listBranchesValidator = z.object({
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  search: z.string().trim().optional(),
  status: z.enum(["ACTIVE", "INACTIVE", "SUSPENDED"]).optional(),
  branchType: z.string().trim().optional(),
  city: z.string().trim().optional(),
});

export type ListBranchesInput = z.infer<typeof listBranchesValidator>;
