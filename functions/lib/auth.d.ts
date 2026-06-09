import { Request } from "firebase-functions/v2/https";
import express from "express";
export type TypedResponse<T = any> = express.Response<T>;
/**
 * Verifies the Firebase ID token from the Authorization header.
 * Throws an error if unauthorized.
 */
export declare function requireAuth(req: Request): Promise<string>;
//# sourceMappingURL=auth.d.ts.map