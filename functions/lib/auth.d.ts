import { Request } from "firebase-functions/v2/https";
import express from "express";
export type TypedResponse<T = any> = express.Response<T>;
export declare const requireAuth: (req: Request, res: TypedResponse, next: (uid: string) => void) => void;
//# sourceMappingURL=auth.d.ts.map