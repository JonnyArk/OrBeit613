import { getAuth } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

export interface TypedRequest {
    method: string;
    headers: {
        authorization?: string;
        [key: string]: string | string[] | undefined;
    };
    body: unknown;
    query: Record<string, unknown>;
}

export interface TypedResponse {
    status(code: number): this;
    json(data: unknown): this;
    send(data: string): this;
    set(field: string, value: string): this;
}

export async function requireAuth(req: TypedRequest, res: TypedResponse): Promise<string | null> {
    if (req.method === "OPTIONS") {
        res.set("Access-Control-Allow-Origin", "*");
        res.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        res.set("Access-Control-Allow-Headers", "Content-Type, Authorization");
        res.status(204).send("");
        return "OPTIONS";
    }

    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthenticated request attempt");
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (error) {
        logger.warn("Invalid token provided", { error });
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
