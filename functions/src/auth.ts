import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";
import { Request } from "firebase-functions/v2/https";
import express from "express";
// eslint-disable-next-line @typescript-eslint/no-require-imports
import cors = require("cors");

const corsHandler = cors({ origin: true });

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse<T = any> = express.Response<T>;

export async function requireAuth(req: Request): Promise<{ uid: string }> {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith("Bearer ")) {
        throw new Error("Unauthorized: Missing or invalid token");
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return { uid: decodedToken.uid };
    } catch (error) {
        logger.error("Authentication failed", { error });
        throw new Error("Unauthorized: Invalid token");
    }
}

export function withAuthAndCors(handler: (req: Request, res: TypedResponse) => Promise<void>) {
    return (req: Request, res: express.Response) => {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        corsHandler(req, res as any, () => {
            (async () => {
                try {
                    await requireAuth(req);
                    await handler(req, res as TypedResponse);
                } catch (error) {
                    if (!res.headersSent) {
                        logger.error("Request failed in withAuthAndCors", { error });
                        const msg = error instanceof Error ? error.message : "Unknown error";
                        const status = msg.startsWith("Unauthorized") ? 401 : 500;
                        res.status(status).json({ success: false, error: msg });
                    }
                }
            })();
        });
    };
}
