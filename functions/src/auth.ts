import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (data: unknown) => void;
}

export interface AuthRequest {
    headers: {
        authorization?: string;
        [key: string]: string | string[] | undefined;
    };
}

/**
 * Validates the Firebase ID token from the Authorization header.
 *
 * @param request - The HTTP request object containing headers
 * @returns The decoded UID if valid, or null if unauthorized
 */
export async function requireAuth(request: AuthRequest): Promise<string | null> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthorized request: Missing or invalid Bearer token");
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];

    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (_error) {
        logger.error("Unauthorized request: Token verification failed", { error: _error });
        return null;
    }
}
