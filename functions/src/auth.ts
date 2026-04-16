import { getAuth } from "firebase-admin/auth";
import type { Request } from "firebase-functions/v2/https";

export type TypedResponse = {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (data: unknown) => void;
};

export async function requireAuth(
    request: Request,
    response: TypedResponse
): Promise<string | null> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        response.status(401).json({ error: "Unauthorized: Missing auth token" });
        return null;
    }

    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch {
        response.status(401).json({ error: "Unauthorized: Invalid auth token" });
        return null;
    }
}
