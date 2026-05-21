import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedRequest {
    headers: {
        authorization?: string;
    };
    body: unknown;
    method: string;
}

export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (data: unknown) => void;
}

export async function requireAuth(
    request: TypedRequest,
    response: TypedResponse
): Promise<{ uid: string } | null> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Missing or invalid authorization header");
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return { uid: decodedToken.uid };
    } catch (error) {
        logger.warn("Invalid ID token", { error });
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
