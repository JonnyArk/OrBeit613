import { getAuth } from "firebase-admin/auth";
import { logger } from "firebase-functions/v2";
import express from "express";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse<T = any> = express.Response<T>;

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export async function requireAuth(req: any): Promise<boolean> {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    logger.warn("Missing or invalid authorization header");
    return false;
  }

  const idToken = authHeader.split("Bearer ")[1];
  try {
    const decodedToken = await getAuth().verifyIdToken(idToken);
    req.user = decodedToken;
    return true;
  } catch (error) {
    logger.error("Error verifying Firebase ID token:", error);
    return false;
  }
}
