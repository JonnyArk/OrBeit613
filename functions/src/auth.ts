import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedRequest {
    headers: {
        authorization?: string;
        [key: string]: string | string[] | undefined;
    };
    body?: unknown;
    method?: string;
}

export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (data: unknown) => void;
}

/**
 * Requires a valid Firebase ID token in the Authorization header.
 * @returns the decoded user ID if authenticated, or null if unauthorized.
 */
export async function requireAuth(
    req: TypedRequest,
    res: TypedResponse
): Promise<string | null> {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith("Bearer ")) {
        logger.error("Unauthorized: Missing or invalid authorization header");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch (error) {
        logger.error("Unauthorized: Invalid ID token", { error });
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
