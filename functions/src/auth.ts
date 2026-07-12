import { getAuth } from "firebase-admin/auth";
import { Request } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type TypedResponse = any;

/**
 * Validates a Firebase ID Token from the Authorization header.
 *
 * @param request The incoming HTTP request
 * @param response The HTTP response object
 * @returns The decoded ID token if valid, otherwise responds with 401 and returns null
 */
export async function validateAuth(request: Request, response: TypedResponse) {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthorized: Missing or invalid Authorization header");
        response.status(401).json({ error: "Unauthorized: Missing or invalid Authorization header" });
        return null;
    }

    const idToken = authHeader.split("Bearer ")[1];

    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken;
    } catch (error) {
        logger.error("Error verifying auth token", { error });
        response.status(401).json({ error: "Unauthorized: Invalid token" });
        return null;
    }
}
