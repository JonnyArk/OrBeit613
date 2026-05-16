import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedRequest {
    headers: {
        authorization?: string;
    };
}

export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
}

/**
 * Secures HTTP endpoints by verifying Firebase ID tokens.
 *
 * @param request - The HTTP request
 * @param response - The HTTP response
 * @returns The decoded user ID if authenticated, null otherwise
 */
export async function requireAuth(
    request: TypedRequest,
    response: TypedResponse
): Promise<string | null> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthenticated request attempt - missing or invalid header");
        response.status(401).json({ error: "Unauthorized: Missing auth token" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (_error) {
        logger.warn("Unauthenticated request attempt - invalid token");
        response.status(401).json({ error: "Unauthorized: Invalid auth token" });
        return null;
    }
}
