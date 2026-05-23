import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedRequest {
    method: string;
    headers: {
        authorization?: string;
        [key: string]: unknown;
    };
    body: unknown;
}

export interface TypedResponse {
    status(code: number): TypedResponse;
    json(data: unknown): void;
    end(): void;
    set(field: string, value: string): TypedResponse;
}

/**
 * Helper to require authentication for onRequest endpoints.
 * Automatically handles CORS preflight requests.
 */
export async function requireAuth(
    req: TypedRequest,
    res: TypedResponse
): Promise<{ uid: string } | null> {
    // Handle CORS preflight
    res.set("Access-Control-Allow-Origin", "*");
    res.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    res.set("Access-Control-Allow-Headers", "Authorization, Content-Type");

    if (req.method === "OPTIONS") {
        res.status(204).end();
        return null;
    }

    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthenticated request: missing or invalid Authorization header");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return { uid: decodedToken.uid };
    } catch (error) {
        logger.error("Authentication failed", { error });
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
