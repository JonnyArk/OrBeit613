import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedRequest {
    headers: {
        authorization?: string;
    };
    [key: string]: unknown;
}

export interface TypedResponse {
    status: (code: number) => this;
    json: (data: unknown) => void;
    [key: string]: unknown;
}

/**
 * Validates the Firebase ID token in the authorization header.
 * Returns the decoded token if valid, or null if invalid.
 * If invalid, it also sends the appropriate 401 response.
 */
export async function requireAuth(req: TypedRequest, res: TypedResponse): Promise<unknown | null> {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];

    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken;
    } catch (_error) {
        logger.error("Authentication failed", { error: _error });
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
