import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";
import { Request } from "firebase-functions/v2/https";
import express from "express";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse<T = any> = express.Response<T>;

export async function requireAuth(req: Request): Promise<string> {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        throw new Error("Unauthorized: Missing or invalid Authorization header");
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (error) {
        logger.error("Error verifying Firebase ID token", { error });
        throw new Error("Unauthorized: Invalid token");
    }
}
