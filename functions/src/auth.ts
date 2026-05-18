import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedRequest {
    headers: Record<string, string | string[] | undefined>;
}

export interface TypedResponse {
    status(code: number): this;
    json(data: unknown): void;
}

export async function requireAuth(
    req: TypedRequest,
    res: TypedResponse
): Promise<string | null> {
    const authHeader = req.headers.authorization;
    if (typeof authHeader !== "string" || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthenticated request attempt");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const token = authHeader.substring(7);
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch (error) {
        logger.warn("Invalid token", { error });
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
