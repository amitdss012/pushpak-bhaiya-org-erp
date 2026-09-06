import multer from "multer";
import { statusCode } from "../types/types.js";
import { ErrorResponse } from "../utils/response.util.js";

// Keep files in memory as buffer so they can be streamed directly to Cloudinary / S3
const storage = multer.memoryStorage();

// Allowed image MIME types
const ALLOWED_IMAGE_MIMES = [
  "image/jpeg",
  "image/png",
  "image/webp",
  "image/svg+xml",
  "image/gif",
];

export const uploadLogo = multer({
  storage,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5 MB max
  },
  fileFilter: (_req, file, cb) => {
    if (ALLOWED_IMAGE_MIMES.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(
        new ErrorResponse(
          `Invalid file format '${file.mimetype}'. Only JPEG, PNG, WEBP, and SVG images are permitted.`,
          statusCode.Bad_Request
        )
      );
    }
  },
});
