import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedResponse {
    status(code: number): this;
    json(data: unknown): void;
}

export async function requireAuth(
    request: { headers: { authorization?: string } },
    response: TypedResponse
): Promise<boolean> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.error("Missing or invalid authorization header");
        response.status(401).json({ error: "Unauthorized" });
        return false;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        await getAuth().verifyIdToken(idToken);
        return true;
    } catch (_error) {
        logger.error("Invalid ID token", { error: _error });
        response.status(401).json({ error: "Unauthorized" });
        return false;
    }
}
