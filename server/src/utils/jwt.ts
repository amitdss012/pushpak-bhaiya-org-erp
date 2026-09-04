import crypto from "crypto";
import jwt, { type SignOptions } from "jsonwebtoken";
import { ENV } from "../config/env.js";

/**
 * Generate a signed JWT token using the secret configured in ENV.
 * @param payload Object payload to encode
 * @param expiresIn Expiration string (e.g. '15m', '7d') or number of seconds (default '15m')
 * @param options Additional jsonwebtoken options
 * @returns Signed JWT string
 */
export const generateToken = <T extends object>(
  payload: T,
  expiresIn: string | number = "15m",
  options?: Omit<SignOptions, "expiresIn">
): string => {
  const secret = ENV.JWT_SECRET as jwt.Secret;
  return jwt.sign(payload, secret, {
    expiresIn: expiresIn as any,
    ...options,
  });
};

/**
 * Verify and decode a JWT token using the secret configured in ENV.
 * @param token JWT string to verify
 * @returns Decoded payload typed as T
 */
export const verifyToken = <T = any>(token: string): T => {
  const secret = ENV.JWT_SECRET as jwt.Secret;
  return jwt.verify(token, secret) as T;
};

/**
 * Decode a JWT token without verifying its signature.
 * @param token JWT string to decode
 * @returns Decoded payload or null
 */
export const decodeToken = <T = any>(token: string): T | null => {
  return jwt.decode(token) as T | null;
};

/**
 * Compute SHA-256 hash of a token string (used for storing refresh tokens and access token hashes securely).
 * @param token Raw token string
 * @returns Hex-encoded SHA-256 hash
 */
export const hashToken = (token: string): string => {
  return crypto.createHash("sha256").update(token).digest("hex");
};

/**
 * Generate cryptographically secure random hexadecimal token (for refresh tokens, password reset tokens, etc.).
 * @param bytes Number of random bytes (default 40 -> 80 hex characters)
 * @returns Hex-encoded random string
 */
export const generateRandomToken = (bytes: number = 40): string => {
  return crypto.randomBytes(bytes).toString("hex");
};