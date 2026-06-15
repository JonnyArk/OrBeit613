import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";
import express from "express";
import { Request } from "firebase-functions/v2/https";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse<T = any> = express.Response<T>;

export async function requireAuth(req: Request, res: TypedResponse): Promise<string | null> {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ error: "Unauthorized: Missing authentication" });
        return null;
    }
    const token = authHeader.split("Bearer ")[1];
    try {
        const decoded = await getAuth().verifyIdToken(token);
        return decoded.uid;
    } catch (error) {
        logger.error("Authentication failed", { error });
        res.status(401).json({ error: "Unauthorized: Invalid token" });
        return null;
    }
}
