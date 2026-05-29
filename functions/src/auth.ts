import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedRequest {
    method: string;
    headers: Record<string, string | string[] | undefined>;
}

export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (body?: unknown) => void;
    end: () => void;
}

export async function requireAuth(req: TypedRequest, res: TypedResponse): Promise<boolean> {
    if (req.method === "OPTIONS") {
        res.status(204).send();
        return false;
    }

    const authHeader = req.headers.authorization;
    if (typeof authHeader !== "string" || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthorized: Missing or invalid Authorization header");
        res.status(401).json({ error: "Unauthorized" });
        return false;
    }

    const token = authHeader.substring(7);
    try {
        await getAuth().verifyIdToken(token);
        return true;
    } catch (error) {
        logger.warn("Unauthorized: Invalid token", { error });
        res.status(401).json({ error: "Unauthorized" });
        return false;
    }
}
