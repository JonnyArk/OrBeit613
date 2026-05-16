export interface TypedRequest {
    headers: {
        authorization?: string;
    };
}
export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
}
/**
 * Secures HTTP endpoints by verifying Firebase ID tokens.
 *
 * @param request - The HTTP request
 * @param response - The HTTP response
 * @returns The decoded user ID if authenticated, null otherwise
 */
export declare function requireAuth(request: TypedRequest, response: TypedResponse): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map