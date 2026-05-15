import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedResponse {
    status(code: number): TypedResponse;
    json(data: unknown): void;
}

export interface AuthRequest {
    headers: {
        authorization?: string;
    };
}

/**
 * Verifies the Firebase ID token in the Authorization header.
 * Returns the UID if successful, or null if unauthorized (and sends 401 response).
 */
export async function requireAuth(
    request: AuthRequest,
    response: TypedResponse
): Promise<string | null> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.error("Unauthorized: Missing or invalid authorization header");
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (_error) {
        logger.error("Unauthorized: Invalid ID token", { error: _error });
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
