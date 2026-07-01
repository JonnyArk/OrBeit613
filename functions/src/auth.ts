import { getAuth } from "firebase-admin/auth";
import type { Request } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

// eslint-disable-next-line @typescript-eslint/no-require-imports
import cors = require("cors");

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse = any;

export const requireAuth = (
    req: Request,
    res: TypedResponse,
    handler: (uid: string) => Promise<void>
): void => {
    cors({ origin: true })(req, res, async () => {
        try {
            const auth = req.headers.authorization;
            if (!auth || !auth.startsWith("Bearer ")) {
                res.status(401).json({ error: "Unauthorized" });
                return;
            }
            const idToken = auth.split("Bearer ")[1];
            const decoded = await getAuth().verifyIdToken(idToken);
            await handler(decoded.uid);
        } catch (error) {
            logger.error("Authentication failed", { error });
            res.status(401).json({ error: "Unauthorized" });
        }
    });
};
