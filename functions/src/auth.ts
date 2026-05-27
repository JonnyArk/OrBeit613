import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedRequest {
    method: string;
    headers: {
        authorization?: string;
        [key: string]: string | string[] | undefined;
    };
    body: unknown;
}

export interface TypedResponse {
    status(code: number): TypedResponse;
    json(data: unknown): void;
    end(): void;
    set(field: string, value: string): TypedResponse;
}

/**
 * Verifies the Firebase ID token in the Authorization header.
 * Allows OPTIONS requests for CORS preflight.
 */
export async function requireAuth(
    request: TypedRequest,
    response: TypedResponse
): Promise<boolean> {
    if (request.method === "OPTIONS") {
        response.status(204).end();
        return false; // Stop further processing for preflight
    }

    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthenticated request: Missing or invalid Authorization header");
        response.status(401).json({ error: "Unauthorized" });
        return false;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        await getAuth().verifyIdToken(idToken);
        return true;
    } catch (error) {
        logger.warn("Unauthenticated request: Invalid token");
        response.status(401).json({ error: "Unauthorized" });
        return false;
    }
}
