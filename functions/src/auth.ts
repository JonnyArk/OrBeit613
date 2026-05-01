import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export type TypedResponse = {
    json: (data: unknown) => void;
    status: (code: number) => TypedResponse;
    send: (data: string) => void;
};

export async function requireAuth(
    request: { headers: { authorization?: string } },
    response: TypedResponse
): Promise<string | null> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.error("Unauthorized: Missing or invalid authorization header");
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (_error) {
        logger.error("Unauthorized: Invalid ID token", { error: _error });
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
