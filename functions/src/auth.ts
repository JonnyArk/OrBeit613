/**
 * Authentication helpers for Firebase Cloud Functions
 */
import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedRequest {
    headers: Record<string, string | string[] | undefined>;
    method: string;
}

export interface TypedResponse {
    status(code: number): this;
    json(data: unknown): this;
    send(data: unknown): this;
}

export interface AuthContext {
    uid: string;
}

/**
 * Verifies the Firebase ID token in the Authorization header.
 * Allows OPTIONS requests to pass through for CORS.
 *
 * @param request - The incoming HTTP request
 * @param response - The HTTP response
 * @returns AuthContext if successful, null otherwise
 */
export async function requireAuth(
    request: TypedRequest,
    response: TypedResponse
): Promise<AuthContext | null> {
    if (request.method === "OPTIONS") {
        response.status(204).send("");
        return null;
    }

    const authHeader = request.headers.authorization;
    if (typeof authHeader !== "string" || !authHeader.startsWith("Bearer ")) {
        logger.warn("Missing or invalid authorization header");
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return { uid: decodedToken.uid };
    } catch (error) {
        logger.error("Error verifying ID token", { error });
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
