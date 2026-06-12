import { Request } from "firebase-functions/v2/https";
import express from "express";
export type TypedResponse<T = any> = express.Response<T>;
export declare const requireAuth: (req: Request, res: express.Response) => Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map