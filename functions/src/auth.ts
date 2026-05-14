import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (data: unknown) => void;
}

export const requireAuth = async (
    request: { headers: { authorization?: string } },
    response: TypedResponse
): Promise<string | null> => {
    const authHeader = request.headers.authorization;
    if (!authHeader?.startsWith("Bearer ")) {
        logger.error("Unauthorized: Missing or invalid authorization header");
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }

    try {
        const token = authHeader.split("Bearer ")[1];
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch (_error) {
        logger.error("Unauthorized: Token verification failed", { _error });
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
};
