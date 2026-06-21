import { Request } from "firebase-functions/v2/https";
import express from "express";
export type TypedResponse<T = any> = express.Response<T>;
export declare function requireAuth(req: Request): Promise<{
    uid: string;
}>;
export declare function withAuthAndCors(handler: (req: Request, res: TypedResponse) => Promise<void>): (req: Request, res: express.Response) => void;
//# sourceMappingURL=auth.d.ts.map