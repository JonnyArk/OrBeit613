import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";
import cors from "cors";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type TypedResponse = any;
// eslint-disable-next-line @typescript-eslint/no-explicit-any
type TypedRequest = any;

const corsHandler = cors({ origin: true });

export const withAuth = (
    req: TypedRequest,
    res: TypedResponse,
    handler: (req: TypedRequest, res: TypedResponse, uid: string) => Promise<void>
) => {
    return corsHandler(req, res, async () => {
        const authHeader = req.headers.authorization;
        if (!authHeader || !authHeader.startsWith("Bearer ")) {
            logger.warn("Unauthorized request: Missing or invalid authorization header");
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        const idToken = authHeader.split("Bearer ")[1];
        try {
            const decodedToken = await getAuth().verifyIdToken(idToken);
            await handler(req, res, decodedToken.uid);
        } catch (error) {
            logger.error("Authentication error", { error });
            res.status(401).json({ error: "Unauthorized" });
        }
    });
};
