import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";
import { Request } from "firebase-functions/v2/https";
import cors from "cors";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type TypedResponse = any;

const corsHandler = cors({ origin: true });

export const withAuth = (
    handler: (req: Request, res: TypedResponse, uid: string) => Promise<void>
) => {
    return (req: Request, res: TypedResponse) => {
        corsHandler(req, res, async () => {
            const authHeader = req.headers.authorization;
            if (!authHeader || !authHeader.startsWith("Bearer ")) {
                logger.warn("Unauthorized request: Missing or invalid Authorization header");
                res.status(401).json({ error: "Unauthorized" });
                return;
            }

            const token = authHeader.split("Bearer ")[1];
            try {
                const decodedToken = await getAuth().verifyIdToken(token);
                const uid = decodedToken.uid;
                await handler(req, res, uid);
            } catch (error) {
                logger.error("Unauthorized request: Token verification failed", { error });
                res.status(401).json({ error: "Unauthorized" });
            }
        });
    };
};
