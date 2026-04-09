import { Request } from "firebase-functions/v2/https";
import { getAuth } from "firebase-admin/auth";

export type TypedResponse = {
    status: (code: number) => {
        json: (data: Record<string, unknown>) => void;
    };
    json: (data: Record<string, unknown>) => void;
};

export async function requireAuth(request: Request, response: TypedResponse): Promise<string | null> {
    const authHeader = request.headers.authorization;
    if (!authHeader?.startsWith("Bearer ")) {
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
