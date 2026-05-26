import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";
import type { DecodedIdToken } from "firebase-admin/auth";

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
    send(body: string): void;
    set(field: string, value: string): void;
}

/**
 * Validates the Firebase ID token in the Authorization header.
 * Allows OPTIONS requests for CORS preflight.
 *
 * @param request The incoming HTTP request
 * @param response The HTTP response
 * @returns The decoded token if valid, true if OPTIONS request, or null if invalid
 */
export async function requireAuth(
    request: unknown,
    response: unknown
): Promise<DecodedIdToken | boolean | null> {
    const req = request as unknown as TypedRequest;
    const res = response as unknown as TypedResponse;

    // Allow CORS preflight requests
    if (req.method === "OPTIONS") {
        res.set("Access-Control-Allow-Origin", "*");
        res.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        res.set("Access-Control-Allow-Headers", "Authorization, Content-Type");
        res.status(204).send("");
        return true;
    }

    // Set CORS headers for actual requests
    res.set("Access-Control-Allow-Origin", "*");

    // Extract the token
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];

    try {
        return await getAuth().verifyIdToken(idToken);
    } catch (error) {
        logger.error("Error verifying Firebase ID token", { error });
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
