import { getAuth } from "firebase-admin/auth";
import { Request } from "firebase-functions/v2/https";
import * as express from "express";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse<T = any> = express.Response<T>;

export async function requireAuth(req: Request, res: TypedResponse): Promise<string | null> {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const token = authHeader.substring(7);
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch {
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
