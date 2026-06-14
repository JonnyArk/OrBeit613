import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import * as express from "express";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse<T = any> = express.Response<T>;

export async function requireAuth(req: express.Request, res: express.Response): Promise<string | null> {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await admin.auth().verifyIdToken(token);
        return decodedToken.uid;
    } catch (error) {
        logger.error("Authentication failed", { error });
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
