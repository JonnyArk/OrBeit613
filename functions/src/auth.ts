import { Request } from "express";
import type { Response } from "express";
import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse<T = any> = Response<T>;

export interface AuthenticatedRequest extends Request {
    user?: {
        uid: string;
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        [key: string]: any;
    };
}

export const requireAuth = async (
    req: AuthenticatedRequest,
    res: TypedResponse,
    next: () => Promise<void> | void
) => {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ error: "Unauthorized" });
        return;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        req.user = decodedToken;
        await next();
    } catch (error) {
        logger.error("Authentication failed", { error });
        res.status(401).json({ error: "Unauthorized" });
    }
};
