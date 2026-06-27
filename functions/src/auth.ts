// eslint-disable-next-line @typescript-eslint/no-require-imports
import cors = require("cors");
import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";
import { Request } from "firebase-functions/v2/https";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type TypedResponse = any;

export const corsHandler = cors({ origin: true });

export const requireAuth = async (req: Request, res: TypedResponse): Promise<string | null> => {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthorized request: Missing or invalid Authorization header");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch {
        logger.warn("Unauthorized request: Invalid token");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
};
