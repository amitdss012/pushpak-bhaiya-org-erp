import dotenv from "dotenv";

// Load environment variables from .env file
dotenv.config();

export const ENV = {
  PORT: process.env.PORT || "3000",
  JWT_SECRET: process.env.JWT_SECRET || "123456",

  FRONTEND_URL: process.env.FRONTEND_URL || "",

  // Active Storage Provider: "CLOUDINARY" | "AWS_S3" | "AZURE_BLOB" | "LOCAL"
  STORAGE_PROVIDER: (process.env.STORAGE_PROVIDER || "CLOUDINARY") as
    | "CLOUDINARY"
    | "AWS_S3"
    | "AZURE_BLOB"
    | "LOCAL",

  // Cloudinary Credentials
  cloud_name: process.env.CLOUD_NAME,
  cloud_api_key: process.env.CLOUD_API_KEY,
  cloud_api_secret: process.env.CLOUD_API_SECRET,
  cloud_folder: process.env.CLOUD_FOLDER,

  // AWS S3 Credentials
  aws_s3_bucket: process.env.AWS_S3_BUCKET,
  aws_region: process.env.AWS_REGION || "us-east-1",
  aws_access_key_id: process.env.AWS_ACCESS_KEY_ID,
  aws_secret_access_key: process.env.AWS_SECRET_ACCESS_KEY,

  // Azure Blob Storage Credentials
  azure_storage_account: process.env.AZURE_STORAGE_ACCOUNT,
  azure_storage_key: process.env.AZURE_STORAGE_KEY,
  azure_storage_container: process.env.AZURE_STORAGE_CONTAINER || "assets",
  azure_storage_connection_string: process.env.AZURE_STORAGE_CONNECTION_STRING,

  mode: process.env.NODE_ENV || "DEVELOPMENT",
};