import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedResponse {
    status(code: number): TypedResponse;
    json(data: unknown): void;
}

export async function requireAuth(
    request: { headers: { authorization?: string } },
    response: TypedResponse
): Promise<string | null> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch (error) {
        logger.error("Auth failed", { error });
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
