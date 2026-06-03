import { DecodedIdToken } from "firebase-admin/auth";
import { Request } from "firebase-functions/v2/https";
import express from "express";
export interface TypedRequest extends Request {
    user?: DecodedIdToken;
}
export type TypedResponse = express.Response;
export declare function requireAuth(request: Request, response: express.Response): Promise<DecodedIdToken | null>;
//# sourceMappingURL=auth.d.ts.map