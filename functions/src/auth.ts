import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";
import { Request } from "firebase-functions/v2/https";
import express from "express";

export type TypedResponse = express.Response;

export const requireAuth = async (req: Request, res: TypedResponse): Promise<string | null> => {
  // Allow CORS preflight requests
  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return null;
  }

  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    res.status(401).json({ error: "Unauthorized" });
    return null;
  }

  const idToken = authHeader.split("Bearer ")[1];
  try {
    const decodedToken = await getAuth().verifyIdToken(idToken);
    return decodedToken.uid;
  } catch (error) {
    logger.error("Error verifying auth token", { error });
    res.status(401).json({ error: "Unauthorized" });
    return null;
  }
};
