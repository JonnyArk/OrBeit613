import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export type TypedResponse = {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (body: unknown) => void;
};

export type TypedRequest = {
    headers: { authorization?: string };
    method: string;
    body: unknown;
};

export async function requireAuth(
    request: unknown,
    response: unknown
): Promise<string | null> {
    const req = request as TypedRequest;
    const res = response as unknown as TypedResponse;

    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ error: "Unauthorized: Missing Authorization header" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];

    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (error) {
        logger.error("Authentication failed", { error });
        res.status(401).json({ error: "Unauthorized: Invalid token" });
        return null;
    }
}
