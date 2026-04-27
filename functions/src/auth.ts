import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export type TypedResponse = {
    status: (code: number) => { json: (data: unknown) => void };
    json: (data: unknown) => void;
};

export async function requireAuth(
    request: { headers: { authorization?: string } },
    response: TypedResponse
): Promise<string | null> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.error("Unauthorized: Missing or invalid authorization header");
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (error) {
        logger.error("Unauthorized: Token verification failed", { error });
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
