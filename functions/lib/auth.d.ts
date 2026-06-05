import { Request } from "firebase-functions/v2/https";
import express from "express";
export type TypedResponse = express.Response;
export declare const requireAuth: (req: Request, res: TypedResponse) => Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map