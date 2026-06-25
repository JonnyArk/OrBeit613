import { getAuth } from "firebase-admin/auth";
import { Request } from "express";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse<T = any> = {
    status(code: number): TypedResponse<T>;
    json(data: T): void;
    send(data: string): void;
};

export async function requireAuth(req: Request, res: TypedResponse): Promise<string | null> {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ error: "Unauthorized: Missing token" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch {
        res.status(401).json({ error: "Unauthorized: Invalid token" });
        return null;
    }
}
