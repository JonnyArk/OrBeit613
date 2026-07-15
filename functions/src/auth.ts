import cors from "cors";
import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";
import type { Request } from "firebase-functions/v2/https";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse = any;

const corsHandler = cors({ origin: true });

export const requireAuth = (
    handler: (req: Request, res: TypedResponse, uid: string) => Promise<void>
) => {
    return (req: Request, res: TypedResponse): void => {
        corsHandler(req, res, async () => {
            const authHeader = req.headers.authorization;
            if (!authHeader || !authHeader.startsWith("Bearer ")) {
                logger.warn("Unauthorized request: Missing token");
                res.status(401).json({ error: "Unauthorized" });
                return;
            }

            try {
                const token = authHeader.split("Bearer ")[1];
                const decodedToken = await getAuth().verifyIdToken(token);
                await handler(req, res, decodedToken.uid);
            } catch (error) {
                logger.warn("Unauthorized request: Invalid token", { error });
                res.status(401).json({ error: "Unauthorized" });
            }
        });
    };
};
