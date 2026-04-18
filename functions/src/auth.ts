import { getAuth } from "firebase-admin/auth";

export type TypedResponse = {
    status: (code: number) => { json: (data: unknown) => void };
    json: (data: unknown) => void;
};

export type TypedRequest = {
    headers: { authorization?: string };
    method: string;
    body: unknown;
};

/**
 * Validates the Authorization header and verifies the Firebase ID token.
 *
 * @param req - The HTTP request with headers
 * @param res - The HTTP response for error handling
 * @returns The authenticated user's ID (uid), or null if unauthorized
 */
export async function requireAuth(req: TypedRequest, res: TypedResponse): Promise<string | null> {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ error: "Unauthorized: Missing or invalid Authorization header" });
        return null;
    }

    const token = authHeader.split("Bearer ")[1];

    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        return decodedToken.uid;
    } catch {
        res.status(401).json({ error: "Unauthorized: Invalid token" });
        return null;
    }
}
