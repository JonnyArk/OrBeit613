import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export type TypedResponse = {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (data: unknown) => void;
};

export async function requireAuth(
    request: { headers: Record<string, string | string[] | undefined> },
    response: TypedResponse
): Promise<string | null> {
    const authHeader = request.headers.authorization;

    if (typeof authHeader !== "string" || !authHeader.startsWith("Bearer ")) {
        response.status(401).json({ error: "Unauthorized: Missing or invalid token" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch {
        logger.warn("Unauthorized: Invalid token");
        response.status(401).json({ error: "Unauthorized: Invalid token" });
        return null;
    }
}
