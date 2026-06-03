import { getAuth, DecodedIdToken } from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";
import { Request } from "firebase-functions/v2/https";
import express from "express";

export interface TypedRequest extends Request {
    user?: DecodedIdToken;
}

export type TypedResponse = express.Response;

export async function requireAuth(
    request: Request,
    response: express.Response
): Promise<DecodedIdToken | null> {
    // Allow CORS preflight requests
    if (request.method === "OPTIONS") {
        response.set("Access-Control-Allow-Origin", "*");
        response.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.set("Access-Control-Allow-Headers", "Authorization, Content-Type");
        response.status(204).send("");
        return null;
    }

    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthorized request missing Bearer token");
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }

    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(token);
        (request as unknown as TypedRequest).user = decodedToken;
        return decodedToken;
    } catch (error) {
        logger.error("Error verifying Firebase ID token", { error });
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
