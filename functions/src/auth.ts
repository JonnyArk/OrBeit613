import { getAuth, DecodedIdToken } from "firebase-admin/auth";
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
    send(body?: unknown): this;
}

export interface AuthContext {
    uid: string;
    token: DecodedIdToken;
}

export async function requireAuth(
    request: TypedRequest,
    response: TypedResponse
): Promise<AuthContext | null> {
    if (request.method === "OPTIONS") {
        response.status(204).send("");
        return null;
    }

    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthenticated request attempt");
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];

    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return {
            uid: decodedToken.uid,
            token: decodedToken,
        };
    } catch (error) {
        logger.error("Error verifying Firebase ID token:", { error });
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
