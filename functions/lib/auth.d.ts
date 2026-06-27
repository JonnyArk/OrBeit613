import cors = require("cors");
import { Request } from "firebase-functions/v2/https";
type TypedResponse = any;
export declare const corsHandler: (req: cors.CorsRequest, res: {
    statusCode?: number | undefined;
    setHeader(key: string, value: string): any;
    end(): any;
}, next: (err?: any) => any) => void;
export declare const requireAuth: (req: Request, res: TypedResponse) => Promise<string | null>;
export {};
//# sourceMappingURL=auth.d.ts.map