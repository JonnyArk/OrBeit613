import { getAuth } from "firebase-admin/auth";
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
    status: (code: number) => TypedResponse;
    json: (body: unknown) => TypedResponse;
    send: (body: unknown) => TypedResponse;
}

export const requireAuth = async (req: TypedRequest, res: TypedResponse): Promise<boolean> => {
    if (req.method === "OPTIONS") {
        return true;
    }

    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthenticated request: missing token");
        res.status(401).json({ error: "Unauthorized" });
        return false;
    }

    const token = authHeader.split("Bearer ")[1];
    try {
        await getAuth().verifyIdToken(token);
        return true;
    } catch (error) {
        logger.error("Authentication failed", { error });
        res.status(401).json({ error: "Unauthorized" });
        return false;
    }
};
