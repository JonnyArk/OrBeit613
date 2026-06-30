import * as admin from "firebase-admin";
import { Request } from "firebase-functions/v2/https";
import cors = require("cors");
export declare const corsHandler: (req: cors.CorsRequest, res: {
    statusCode?: number | undefined;
    setHeader(key: string, value: string): any;
    end(): any;
}, next: (err?: any) => any) => void;
export type TypedResponse = any;
export declare const requireAuth: (request: Request, response: TypedResponse) => Promise<admin.auth.DecodedIdToken | null>;
//# sourceMappingURL=auth.d.ts.map