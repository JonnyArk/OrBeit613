import type { Request } from "firebase-functions/v2/https";
type TypedResponse = any;
export declare const withAuth: (handler: (req: Request, res: TypedResponse, uid: string) => Promise<void>) => (req: Request, res: TypedResponse) => void;
export {};
//# sourceMappingURL=auth.d.ts.map