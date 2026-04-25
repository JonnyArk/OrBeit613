import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedRequest {
    headers: { authorization?: string };
    body: unknown;
    method: string;
}

export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
}

export async function requireAuth(
    request: TypedRequest,
    response: TypedResponse
): Promise<string | null> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }

    try {
        const token = authHeader.split("Bearer ")[1];
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch (error) {
        logger.error("Authentication failed", { error });
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
