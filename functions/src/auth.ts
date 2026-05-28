import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedRequest {
    method: string;
    headers: {
        authorization?: string;
        origin?: string;
        [key: string]: string | string[] | undefined;
    };
    body: unknown;
}

export interface TypedResponse {
    status(code: number): this;
    json(body: unknown): void;
    set(field: string, value: string): this;
}

export async function requireAuth(req: unknown, res: unknown): Promise<string | null> {
    const request = req as TypedRequest;
    const response = res as TypedResponse;

    if (request.headers.origin) {
        response.set("Access-Control-Allow-Origin", request.headers.origin);
        response.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.set("Access-Control-Allow-Headers", "Content-Type, Authorization");
    }

    if (request.method === "OPTIONS") {
        response.status(204).json({});
        return null;
    }

    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Missing or invalid authorization header");
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (error) {
        logger.error("Error verifying Firebase ID token", { error });
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
