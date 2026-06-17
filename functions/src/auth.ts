import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";
import { Request } from "firebase-functions/v2/https";
import express from "express";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse<T = any> = express.Response<T>;

export const requireAuth = async (
  req: Request,
  res: TypedResponse,
  next: (uid: string) => Promise<void>
) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    res.status(401).json({ error: "Unauthorized" });
    return;
  }

  const token = authHeader.split("Bearer ")[1];
  try {
    const decodedToken = await getAuth().verifyIdToken(token);
    await next(decodedToken.uid);
  } catch (error) {
    logger.error("Auth error", { error });
    res.status(401).json({ error: "Unauthorized" });
  }
};
