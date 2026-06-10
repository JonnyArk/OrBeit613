import express from "express";
import * as logger from "firebase-functions/logger";
import { getAuth } from "firebase-admin/auth";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse<T = any> = express.Response<T>;

export const requireAuth = async (req: express.Request, res: TypedResponse) => {
    const authorization = req.headers.authorization;
    if (!authorization || !authorization.startsWith("Bearer ")) {
        logger.error("Missing or invalid authorization header");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const token = authorization.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken;
    } catch (error) {
        logger.error("Error verifying Firebase ID token", { error });
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
};
