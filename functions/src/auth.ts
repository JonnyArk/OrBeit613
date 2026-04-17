import { getAuth } from "firebase-admin/auth";

export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
}

export async function requireAuth(request: { headers: { authorization?: string } }): Promise<string> {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        throw new Error("Unauthorized");
    }
    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch {
        throw new Error("Unauthorized");
    }
}
