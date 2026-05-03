import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedRequest {
    headers: { authorization?: string };
}

export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
}

/**
 * Validates Authorization header and returns authenticated user's ID.
 */
export async function requireAuth(req: TypedRequest): Promise<string> {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith("Bearer ")) {
        throw new Error("Unauthorized");
    }

    try {
        const idToken = authHeader.split("Bearer ")[1];
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (_error) {
        logger.error("Authentication failed", { _error });
        throw new Error("Unauthorized");
    }
}
