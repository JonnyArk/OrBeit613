import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export type TypedResponse = {
  status: (code: number) => { json: (data: unknown) => void };
  json: (data: unknown) => void;
};

export async function requireAuth(
  request: { headers: { authorization?: string } },
  response: TypedResponse
): Promise<string | null> {
  const authHeader = request.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    response.status(401).json({ error: "Unauthorized: Missing or invalid authorization header" });
    return null;
  }

  const idToken = authHeader.split("Bearer ")[1];
  try {
    const decodedToken = await getAuth().verifyIdToken(idToken);
    return decodedToken.uid;
  } catch (error) {
    logger.error("Error verifying Firebase ID token", { error });
    response.status(403).json({ error: "Unauthorized: Invalid token" });
    return null;
  }
}
