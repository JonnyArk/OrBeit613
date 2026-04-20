import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (body: string) => void;
}

export interface AuthRequest {
    headers: {
        authorization?: string;
        [key: string]: string | string[] | undefined;
    };
    body?: unknown;
    method?: string;
}

/**
 * Validates the authorization header and returns the authenticated user's ID.
 * Securely mitigates IDOR and spoofing by enforcing token validation.
 *
 * @param request HTTP request
 * @param response HTTP response
 * @returns The authenticated UID if valid, null if unauthorized
 */
export async function requireAuth(
    request: AuthRequest,
    response: TypedResponse
): Promise<string | null> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthorized request: Missing or invalid authorization header");
        response.status(401).json({ error: "Unauthorized: Missing authorization header" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (error) {
        logger.warn("Unauthorized request: Invalid token", { error });
        response.status(401).json({ error: "Unauthorized: Invalid token" });
        return null;
    }
}
