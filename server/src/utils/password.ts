import bcryptjs from "bcryptjs";

/**
 * Hash a plain text password using bcryptjs.
 * @param password Plain text password
 * @param saltRounds Number of salt rounds (default 10)
 * @returns Promise resolving to the password hash
 */
export const hashPassword = async (
  password: string,
  saltRounds: number = 10
): Promise<string> => {
  return bcryptjs.hash(password, saltRounds);
};

/**
 * Compare a plain text password with a hashed password.
 * @param password Plain text password
 * @param hash Hashed password to compare against
 * @returns Promise resolving to boolean indicating match
 */
export const comparePassword = async (
  password: string,
  hash: string
): Promise<boolean> => {
  return bcryptjs.compare(password, hash);
};

/**
 * Synchronously hash a plain text password using bcryptjs.
 * @param password Plain text password
 * @param saltRounds Number of salt rounds (default 10)
 * @returns Password hash string
 */
export const hashPasswordSync = (
  password: string,
  saltRounds: number = 10
): string => {
  return bcryptjs.hashSync(password, saltRounds);
};

/**
 * Synchronously compare a plain text password with a hashed password.
 * @param password Plain text password
 * @param hash Hashed password to compare against
 * @returns boolean indicating match
 */
export const comparePasswordSync = (
  password: string,
  hash: string
): boolean => {
  return bcryptjs.compareSync(password, hash);
};