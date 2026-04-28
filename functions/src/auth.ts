import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

/**
 * Structural type for Express response to avoid @types/express dependency
 */
export type TypedResponse = {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (body: unknown) => void;
};

/**
 * Verifies Firebase ID token from Authorization header.
 *
 * @param request - HTTP request object with headers
 * @returns Promise resolving to the authenticated user's UID
 * @throws Error if authentication fails
 */
export async function requireAuth(
    request: { headers: { authorization?: string } }
): Promise<string> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        throw new Error("Unauthorized: Missing or invalid authorization header");
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (error) {
        logger.error("Token verification failed", { error });
        throw new Error("Unauthorized: Invalid token");
    }
}
