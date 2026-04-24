import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export type TypedResponse = {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
};

export type AuthRequest = {
    headers: {
        authorization?: string;
    };
};

export async function requireAuth(req: AuthRequest, res: TypedResponse): Promise<string | null> {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.error("Missing or invalid authorization header");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (error) {
        logger.error("Error verifying ID token", { error });
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
