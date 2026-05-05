import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface AuthRequest {
    headers: {
        authorization?: string;
    };
}

export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
}

/**
 * Validates the Authorization header and returns the authenticated user's ID.
 * @param request The HTTP request object.
 * @returns The authenticated user's UID.
 * @throws Error if authentication fails.
 */
export async function requireAuth(request: AuthRequest): Promise<string> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        throw new Error("Unauthorized");
    }

    const token = authHeader.substring(7);
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch (_error) {
        logger.error("Authentication failed", { error: _error });
        throw new Error("Unauthorized");
    }
}
