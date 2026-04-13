import { getAuth } from "firebase-admin/auth";
import { Request } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

export type TypedResponse = {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
};

export async function requireAuth(
    request: Request,
    response: TypedResponse
): Promise<string | null> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        response.status(401).json({ error: "Unauthorized: Missing or invalid token" });
        return null;
    }

    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch {
        logger.warn("Authentication failed");
        response.status(401).json({ error: "Unauthorized: Invalid token" });
        return null;
    }
}
