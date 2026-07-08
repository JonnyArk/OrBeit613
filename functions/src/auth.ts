import cors from "cors";
import { getAuth } from "firebase-admin/auth";
import type { Request } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type TypedResponse = any;

const corsHandler = cors({ origin: true });

export const withAuth = (handler: (req: Request, res: TypedResponse, uid: string) => Promise<void>) => {
    return (req: Request, res: TypedResponse) => {
        corsHandler(req, res, async () => {
            try {
                const authHeader = req.headers.authorization;
                if (!authHeader || !authHeader.startsWith("Bearer ")) {
                    logger.warn("Missing or invalid authorization header");
                    res.status(401).json({ success: false, error: "Unauthorized" });
                    return;
                }

                const idToken = authHeader.split("Bearer ")[1];
                let decodedToken;
                try {
                    decodedToken = await getAuth().verifyIdToken(idToken);
                } catch (error) {
                    logger.warn("Invalid ID token", { error });
                    res.status(401).json({ success: false, error: "Unauthorized" });
                    return;
                }

                await handler(req, res, decodedToken.uid);
            } catch (error) {
                logger.error("Unhandled error in secure endpoint", { error });
                res.status(500).json({ success: false, error: "Internal Server Error" });
            }
        });
    };
};
