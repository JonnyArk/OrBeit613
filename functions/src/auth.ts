import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedResponse {
  status(code: number): TypedResponse;
  json(data: unknown): void;
}

export interface RequestWithAuth {
  headers: {
    authorization?: string;
  };
}

/**
 * Validates the Authorization header and verifies the Firebase ID token.
 * Returns the user ID if successful, otherwise sends a 401 response and returns null.
 */
export async function requireAuth(
  request: RequestWithAuth,
  response: TypedResponse
): Promise<string | null> {
  const authHeader = request.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    response.status(401).json({ error: "Unauthorized" });
    return null;
  }

  const idToken = authHeader.split("Bearer ")[1];
  try {
    const decodedToken = await getAuth().verifyIdToken(idToken);
    return decodedToken.uid;
  } catch (_error) {
    logger.error("Authentication failed", { error: _error });
    response.status(401).json({ error: "Unauthorized" });
    return null;
  }
}
