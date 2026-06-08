import type { Request } from "firebase-functions/v2/https";
import express from "express";
export type TypedResponse = express.Response;
export interface AuthContext {
    uid: string;
}
/**
 * Helper to securely verify Firebase ID tokens.
 * Ensure this occurs after OPTIONS requests so CORS preflight checks do not fail.
 *
 * @param req The incoming request
 * @param res The response object
 * @returns AuthContext if authenticated, null otherwise
 */
export declare function requireAuth(req: Request, res: TypedResponse): Promise<AuthContext | null>;
//# sourceMappingURL=auth.d.ts.map