import { type DecodedIdToken } from "firebase-admin/auth";
export interface TypedRequest {
    headers: {
        authorization?: string;
    };
}
export interface TypedResponse {
    status: (code: number) => {
        json: (data: unknown) => void;
        send: (data: unknown) => void;
    };
    json: (data: unknown) => void;
    send: (data: unknown) => void;
}
/**
 * Verifies the Firebase ID token from the Authorization header.
 */
export declare function requireAuth(req: TypedRequest, res: TypedResponse): Promise<DecodedIdToken | null>;
//# sourceMappingURL=auth.d.ts.map