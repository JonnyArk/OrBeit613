import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface RequestWithAuth {
    headers: {
        authorization?: string;
    };
}

export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
}

/**
 * Verifies the Firebase ID token in the Authorization header.
 *
 * @param req - The HTTP request object.
 * @param res - The HTTP response object.
 * @returns The user's UID if authenticated, or null if unauthorized.
 */
export async function requireAuth(req: RequestWithAuth, res: TypedResponse): Promise<string | null> {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.error("Missing or invalid authorization header");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch (_error) {
        logger.error("Token verification failed");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
