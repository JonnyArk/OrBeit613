export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
}
export interface AuthRequest {
    headers: {
        authorization?: string;
    };
}
/**
 * Helper to securely verify Firebase ID tokens.
 * Returns the authenticated uid if valid, otherwise handles the error response and returns null.
 */
export declare function requireAuth(request: AuthRequest, response: TypedResponse): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map