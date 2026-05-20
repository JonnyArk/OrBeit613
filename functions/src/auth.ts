import { getAuth, DecodedIdToken } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedRequest {
    headers: Record<string, string | string[] | undefined>;
    body: unknown;
    method: string;
}

export interface TypedResponse {
    status(code: number): TypedResponse;
    json(data: unknown): TypedResponse;
    send(data: unknown): TypedResponse;
}

/**
 * Verifies the Firebase ID token in the Authorization header.
 * Returns the decoded token if valid, or null if invalid/missing.
 * If invalid, it automatically sends a 401 response.
 */
export async function requireAuth(
    req: TypedRequest,
    res: TypedResponse
): Promise<DecodedIdToken | null> {
    const authHeader = req.headers.authorization;
    if (typeof authHeader !== "string" || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthorized request: Missing or invalid Authorization header");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken;
    } catch (_error) {
        logger.warn("Unauthorized request: Token verification failed");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
