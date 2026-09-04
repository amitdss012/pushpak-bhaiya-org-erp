import dotenv from "dotenv";

// Load environment variables from .env file
dotenv.config();

export const ENV = {
  PORT: process.env.PORT || "3000",
  JWT_SECRET: process.env.JWT_SECRET || "123456",

  FRONTEND_URL: process.env.FRONTEND_URL || "",

  // Cloudinary Credentials
  cloud_name: process.env.CLOUD_NAME,
  cloud_api_key: process.env.CLOUD_API_KEY,
  cloud_api_secret: process.env.CLOUD_API_SECRET,
  cloud_folder: process.env.CLOUD_FOLDER,

  mode: process.env.NODE_ENV || "DEVELOPMENT",
};