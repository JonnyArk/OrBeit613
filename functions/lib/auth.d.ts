import type { Request } from "firebase-functions/v2/https";
export type TypedResponse = any;
export declare const requireAuth: (req: Request, res: TypedResponse, handler: (uid: string) => Promise<void>) => void;
//# sourceMappingURL=auth.d.ts.map