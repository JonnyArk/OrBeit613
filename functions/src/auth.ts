import { getAuth } from "firebase-admin/auth";
import cors from "cors";

const corsHandler = cors({ origin: true });

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type TypedResponse = any;
// eslint-disable-next-line @typescript-eslint/no-explicit-any
type TypedRequest = any;

/**
 * Secures HTTP Cloud Functions by enforcing CORS and Firebase Authentication.
 */
export const withAuth = (handler: (req: TypedRequest, res: TypedResponse) => Promise<void>) => {
    return (req: TypedRequest, res: TypedResponse) => {
        corsHandler(req, res, async () => {
            try {
                const authHeader = req.headers.authorization;
                if (!authHeader?.startsWith("Bearer ")) {
                    res.status(401).json({ error: "Unauthorized: Missing or invalid token" });
                    return;
                }
                const token = authHeader.split("Bearer ")[1];
                const decodedToken = await getAuth().verifyIdToken(token);
                req.user = decodedToken;

                try {
                    await handler(req, res);
                } catch {
                    // Do not leak stack traces
                    res.status(500).json({ error: "Internal Server Error" });
                }
            } catch {
                res.status(401).json({ error: "Unauthorized: Invalid token" });
            }
        });
    };
};
