import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedResponse {
    status(code: number): TypedResponse;
    json(data: unknown): void;
    send(data: string): void;
    end(): void;
}

export interface TypedRequest {
    headers: Record<string, string | string[] | undefined>;
    method: string;
}

export async function requireAuth(
    req: unknown,
    res: unknown
): Promise<string | null> {
    const request = req as TypedRequest;
    const response = res as TypedResponse;

    if (request.method === "OPTIONS") {
        response.status(204).send("");
        return null;
    }

    const authHeader = request.headers.authorization;
    if (!authHeader || typeof authHeader !== "string" || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthenticated request blocked");
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch (error) {
        logger.error("Token verification failed", { error });
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
