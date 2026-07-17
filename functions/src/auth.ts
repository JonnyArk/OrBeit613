import { getAuth } from "firebase-admin/auth";
import type { Request } from "firebase-functions/v2/https";
import cors from "cors";

const corsHandler = cors({ origin: true });

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type TypedResponse = any;

export const withAuth = (handler: (req: Request, res: TypedResponse) => Promise<void>) => {
    return (req: Request, res: TypedResponse) => {
        corsHandler(req, res, async () => {
            const authHeader = req.headers.authorization;
            if (!authHeader?.startsWith("Bearer ")) {
                res.status(401).json({ error: "Unauthorized" });
                return;
            }
            try {
                await getAuth().verifyIdToken(authHeader.split("Bearer ")[1]);
                await handler(req, res);
            } catch {
                res.status(401).json({ error: "Unauthorized" });
            }
        });
    };
};
