import { Request } from "express";
import type { Response } from "express";
export type TypedResponse<T = any> = Response<T>;
export interface AuthenticatedRequest extends Request {
    user?: {
        uid: string;
        [key: string]: any;
    };
}
export declare const requireAuth: (req: AuthenticatedRequest, res: TypedResponse, next: () => Promise<void> | void) => Promise<void>;
//# sourceMappingURL=auth.d.ts.map