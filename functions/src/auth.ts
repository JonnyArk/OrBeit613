import { Request } from "firebase-functions/v2/https";
import * as express from "express";
import { getAuth } from "firebase-admin/auth";
import cors from "cors";
import * as logger from "firebase-functions/logger";

const corsHandler = cors({ origin: true });

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type TypedResponse = any;

export const withAuth = (
    handler: (req: Request, res: TypedResponse) => Promise<void>
) => {
    return (req: Request, res: express.Response) => {
        corsHandler(req, res, async () => {
            try {
                const authHeader = req.headers.authorization;
                if (!authHeader || !authHeader.startsWith("Bearer ")) {
                    logger.warn("Unauthorized request: missing or invalid authorization header");
                    res.status(401).json({ error: "Unauthorized" });
                    return;
                }

                const idToken = authHeader.split("Bearer ")[1];
                try {
                    await getAuth().verifyIdToken(idToken);
                } catch (error) {
                    logger.warn("Unauthorized request: invalid token", { error });
                    res.status(401).json({ error: "Unauthorized" });
                    return;
                }

                await handler(req, res);
            } catch (error) {
                logger.error("Unhandled error in secure endpoint", { error });
                res.status(500).json({ error: "Internal server error" });
            }
        });
    };
};
