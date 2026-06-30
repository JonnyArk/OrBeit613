import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import { Request } from "firebase-functions/v2/https";

// eslint-disable-next-line @typescript-eslint/no-require-imports
import cors = require("cors");

export const corsHandler = cors({ origin: true });

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse = any;

export const requireAuth = async (
    request: Request,
    response: TypedResponse
): Promise<admin.auth.DecodedIdToken | null> => {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthenticated request");
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await admin.auth().verifyIdToken(token);
        return decodedToken;
    } catch {
        logger.error("Invalid token");
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
};
