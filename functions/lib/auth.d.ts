import * as express from "express";
export type TypedResponse<T = any> = express.Response<T>;
export declare function requireAuth(req: express.Request, res: express.Response): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map