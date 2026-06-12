import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";
import { Request } from "firebase-functions/v2/https";
import express from "express";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse<T = any> = express.Response<T>;

export const requireAuth = async (
    req: Request,
    res: express.Response
): Promise<string | null> => {
    // For OPTIONS preflight, CORS handles it, but in case it passes through
    if (req.method === "OPTIONS") {
        return null;
    }

    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthorized: Missing or invalid Authorization header");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (error) {
        logger.error("Unauthorized: Token verification failed", { error });
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
};
