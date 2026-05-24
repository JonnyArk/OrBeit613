import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedRequest {
    method: string;
    headers: {
        authorization?: string;
        [key: string]: string | string[] | undefined;
    };
    body: unknown;
}

export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (data: unknown) => void;
    end: () => void;
}

export interface AuthContext {
    uid: string;
    email?: string;
}

/**
 * Helper to securely verify Firebase ID tokens for HTTP endpoints.
 * Returns AuthContext if successful, or null if unauthorized (already handles the response).
 */
export async function requireAuth(
    request: unknown,
    response: unknown
): Promise<AuthContext | null> {
    const req = request as TypedRequest;
    const res = response as TypedResponse;

    // Handle CORS preflight requests
    if (req.method === "OPTIONS") {
        res.status(204).send("");
        return null;
    }

    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthenticated request attempt: missing or invalid authorization header");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return {
            uid: decodedToken.uid,
            email: decodedToken.email,
        };
    } catch (error) {
        logger.error("Error verifying Firebase ID token", { error });
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
