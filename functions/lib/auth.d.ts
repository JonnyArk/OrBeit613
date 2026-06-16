import { Request } from "firebase-functions/v2/https";
import express from "express";
export type TypedResponse<T = any> = express.Response<T>;
export declare function requireAuth(req: Request, res: TypedResponse): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map