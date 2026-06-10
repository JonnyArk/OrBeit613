import express from "express";
export type TypedResponse<T = any> = express.Response<T>;
export declare const requireAuth: (req: express.Request, res: TypedResponse) => Promise<import("firebase-admin/auth").DecodedIdToken | null>;
//# sourceMappingURL=auth.d.ts.map