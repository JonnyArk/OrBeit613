import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

/**
 * A simple structural type for an Express-like response to enforce status and JSON.
 */
export interface TypedResponse {
  status(code: number): this;
  json(data: unknown): void;
}

/**
 * Validates the Authorization header from the request and verifies the Firebase ID token.
 * Throws an error if authentication fails.
 *
 * @param request - HTTP request object with headers
 * @returns The decoded Firebase Auth token
 * @throws Error if missing or invalid token
 */
export async function requireAuth(request: { headers: { authorization?: string } }): Promise<unknown> {
  const authHeader = request.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    throw new Error("Missing or invalid Authorization header");
  }

  const idToken = authHeader.split("Bearer ")[1];
  try {
    const decodedToken = await getAuth().verifyIdToken(idToken);
    return decodedToken;
  } catch (error) {
    logger.error("Authentication failed", { error });
    throw new Error("Unauthorized");
  }
}
