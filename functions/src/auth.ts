import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
}

export interface AuthRequest {
    headers: {
        authorization?: string;
    };
}

export async function requireAuth(
    request: AuthRequest,
    response: TypedResponse
): Promise<string | null> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        response.status(401).json({ error: "Unauthorized: Missing or invalid token" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch {
        logger.warn("Unauthorized: Invalid ID token");
        response.status(401).json({ error: "Unauthorized: Invalid token" });
        return null;
    }
}
