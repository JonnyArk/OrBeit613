import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export type TypedResponse = {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
};

export type TypedRequest = {
    headers: { authorization?: string };
    body: unknown;
    method: string;
};

export async function requireAuth(
    req: TypedRequest,
    res: TypedResponse
): Promise<string | null> {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith("Bearer ")) {
        logger.warn("Missing/invalid auth header");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
    try {
        const decodedToken = await getAuth().verifyIdToken(authHeader.split("Bearer ")[1]);
        return decodedToken.uid;
    } catch (error) {
        logger.warn("Invalid token", { error });
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
