import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";
import express from "express";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse<T = any> = express.Response<T>;

export async function requireAuth(
    req: express.Request,
    res: express.Response
): Promise<string | null> {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthenticated request missing Bearer token");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (error) {
        logger.warn("Invalid ID token", { error });
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
