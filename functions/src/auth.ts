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
    status(code: number): this;
    json(data: unknown): this;
    send(data?: unknown): this;
}

/**
 * Validates the Firebase ID token in the authorization header.
 *
 * @param request The incoming HTTP request
 * @param response The HTTP response object
 * @returns A promise that resolves to true if authorized, false otherwise
 */
export async function requireAuth(
    request: TypedRequest,
    response: TypedResponse
): Promise<boolean> {
    // Allow CORS preflight requests
    if (request.method === "OPTIONS") {
        return true;
    }

    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthorized request: Missing or invalid authorization header");
        response.status(401).json({ error: "Unauthorized" });
        return false;
    }

    const token = authHeader.split("Bearer ")[1];
    try {
        await getAuth().verifyIdToken(token);
        return true;
    } catch (error) {
        logger.error("Unauthorized request: Token verification failed", { error: error instanceof Error ? error.message : "Unknown error" });
        response.status(401).json({ error: "Unauthorized" });
        return false;
    }
}
