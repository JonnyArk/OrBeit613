import express from "express";
export type TypedResponse<T = any> = express.Response<T>;
export declare function requireAuth(req: any): Promise<boolean>;
//# sourceMappingURL=auth.d.ts.map