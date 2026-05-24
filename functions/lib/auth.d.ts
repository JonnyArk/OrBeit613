export interface TypedRequest {
    method: string;
    headers: {
        authorization?: string;
        [key: string]: string | string[] | undefined;
    };
    body: unknown;
}
export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (data: unknown) => void;
    end: () => void;
}
export interface AuthContext {
    uid: string;
    email?: string;
}
/**
 * Helper to securely verify Firebase ID tokens for HTTP endpoints.
 * Returns AuthContext if successful, or null if unauthorized (already handles the response).
 */
export declare function requireAuth(request: unknown, response: unknown): Promise<AuthContext | null>;
//# sourceMappingURL=auth.d.ts.map