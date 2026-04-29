import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (data: unknown) => void;
}

export interface AuthContext {
    uid: string;
}

export async function requireAuth(
    request: { headers: { authorization?: string } },
    response: TypedResponse
): Promise<AuthContext | null> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.error("Unauthorized: Missing or invalid Authorization header");
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return { uid: decodedToken.uid };
    } catch (_error) {
        logger.error("Unauthorized: Invalid token", { error: _error });
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
