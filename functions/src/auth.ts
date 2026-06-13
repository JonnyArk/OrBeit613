import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";
import { Request } from "firebase-functions/v2/https";
import express from "express";
import cors from "cors";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse<T = any> = express.Response<T>;

const corsHandler = cors({ origin: true });

export const requireAuth = (
    req: Request,
    res: TypedResponse,
    next: (uid: string) => void
) => {
    corsHandler(req, res, async () => {
        if (req.method === "OPTIONS") {
            return;
        }

        const authHeader = req.headers.authorization;
        if (!authHeader || !authHeader.startsWith("Bearer ")) {
            logger.warn("Unauthenticated request blocked");
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        const idToken = authHeader.split("Bearer ")[1];

        try {
            const decodedToken = await getAuth().verifyIdToken(idToken);
            next(decodedToken.uid);
        } catch (error) {
            logger.error("Token verification failed", { error });
            res.status(401).json({ error: "Unauthorized" });
        }
    });
};
