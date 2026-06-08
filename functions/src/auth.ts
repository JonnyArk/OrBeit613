import { getAuth } from "firebase-admin/auth";
import type { Request } from "firebase-functions/v2/https";
import express from "express";
import * as logger from "firebase-functions/logger";

export type TypedResponse = express.Response;

export interface AuthContext {
    uid: string;
}

/**
 * Helper to securely verify Firebase ID tokens.
 * Ensure this occurs after OPTIONS requests so CORS preflight checks do not fail.
 *
 * @param req The incoming request
 * @param res The response object
 * @returns AuthContext if authenticated, null otherwise
 */
export async function requireAuth(
    req: Request,
    res: TypedResponse
): Promise<AuthContext | null> {
    const authHeader = req.header("authorization");

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthenticated request blocked");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return { uid: decodedToken.uid };
    } catch (error) {
        logger.warn("Invalid token", { error });
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
