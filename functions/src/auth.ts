import { getAuth, DecodedIdToken } from "firebase-admin/auth";
import cors from "cors";
import { Request } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type TypedResponse = any;

const corsHandler = cors({ origin: true });

export const withAuth = (
    handler: (req: Request, res: TypedResponse, uid: string) => Promise<void>
) => {
    return (req: Request, res: TypedResponse) => {
        corsHandler(req, res, async () => {
            const authHeader = req.headers.authorization;
            if (!authHeader?.startsWith("Bearer ")) {
                logger.warn("Unauthenticated request blocked");
                res.status(401).json({ error: "Unauthorized" });
                return;
            }
            let decodedToken: DecodedIdToken;
            try {
                const token = authHeader.split("Bearer ")[1];
                decodedToken = await getAuth().verifyIdToken(token);
            } catch (error) {
                logger.error("Token verification failed", { error });
                res.status(401).json({ error: "Unauthorized" });
                return;
            }
            await handler(req, res, decodedToken.uid);
        });
    };
};
