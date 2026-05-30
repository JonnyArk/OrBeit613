import { DecodedIdToken } from "firebase-admin/auth";
export interface TypedRequest {
    method: string;
    headers: {
        authorization?: string;
        [key: string]: string | string[] | undefined;
    };
    body: unknown;
}
export interface TypedResponse {
    status(code: number): this;
    json(data: unknown): this;
    send(body?: unknown): this;
}
export interface AuthContext {
    uid: string;
    token: DecodedIdToken;
}
export declare function requireAuth(request: TypedRequest, response: TypedResponse): Promise<AuthContext | null>;
//# sourceMappingURL=auth.d.ts.map