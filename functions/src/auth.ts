import { getAuth, type DecodedIdToken } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedRequest {
    headers: { authorization?: string };
}

export interface TypedResponse {
    status: (code: number) => { json: (data: unknown) => void; send: (data: unknown) => void };
    json: (data: unknown) => void;
    send: (data: unknown) => void;
}

/**
 * Verifies the Firebase ID token from the Authorization header.
 */
export async function requireAuth(req: TypedRequest, res: TypedResponse): Promise<DecodedIdToken | null> {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthorized: Missing or invalid Authorization header");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken;
    } catch (error) {
        logger.error("Unauthorized: Invalid token", { error });
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
