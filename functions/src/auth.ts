import { getAuth } from "firebase-admin/auth";
import { Request } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

export type TypedResponse = {
    status: (code: number) => { json: (data: Record<string, unknown>) => void };
    json: (data: Record<string, unknown>) => void;
};

export async function requireAuth(
    request: Request,
    response: TypedResponse
): Promise<string | null> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Missing or invalid Authorization header");
        response.status(401).json({ error: "Unauthorized: Missing token" });
        return null;
    }

    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch {
        logger.warn("Invalid ID token");
        response.status(401).json({ error: "Unauthorized: Invalid token" });
        return null;
    }
}
