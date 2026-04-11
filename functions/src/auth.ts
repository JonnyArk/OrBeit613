import { getAuth } from "firebase-admin/auth";
import { Request } from "firebase-functions/v2/https";

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
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }

    try {
        const token = authHeader.split("Bearer ")[1];
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch {
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
