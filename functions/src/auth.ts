import { getAuth } from "firebase-admin/auth";
import type { Request } from "firebase-functions/v2/https";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse = any;

export async function requireAuth(req: Request, res: TypedResponse): Promise<string | null> {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ error: "Unauthorized: Missing or invalid token" });
        return null;
    }
    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch {
        res.status(401).json({ error: "Unauthorized: Invalid token" });
        return null;
    }
}
