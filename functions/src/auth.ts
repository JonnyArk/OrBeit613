import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
}

export interface AuthRequest {
    headers: {
        authorization?: string;
    };
}

/**
 * Helper to securely verify Firebase ID tokens.
 * Returns the authenticated uid if valid, otherwise handles the error response and returns null.
 */
export async function requireAuth(
    request: AuthRequest,
    response: TypedResponse
): Promise<string | null> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.error("Missing or invalid authorization header");
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (error) {
        logger.error("Error verifying ID token", { error: error instanceof Error ? error.message : "Unknown error" });
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
