import { getAuth } from "firebase-admin/auth";
import cors from "cors";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type TypedResponse = any;

const corsHandler = cors({ origin: true });

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const withAuth = (req: any, res: TypedResponse, handler: (uid: string) => Promise<void>) => {
    corsHandler(req, res, async () => {
        const authHeader = req.headers.authorization;
        if (!authHeader || !authHeader.startsWith("Bearer ")) {
            res.status(401).json({ error: "Unauthorized" });
            return;
        }
        try {
            const token = authHeader.split("Bearer ")[1];
            const decodedToken = await getAuth().verifyIdToken(token);
            await handler(decodedToken.uid);
        } catch {
            res.status(401).json({ error: "Unauthorized" });
        }
    });
};
