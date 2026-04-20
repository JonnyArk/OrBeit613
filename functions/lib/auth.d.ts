export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (body: string) => void;
}
export interface AuthRequest {
    headers: {
        authorization?: string;
        [key: string]: string | string[] | undefined;
    };
    body?: unknown;
    method?: string;
}
/**
 * Validates the authorization header and returns the authenticated user's ID.
 * Securely mitigates IDOR and spoofing by enforcing token validation.
 *
 * @param request HTTP request
 * @param response HTTP response
 * @returns The authenticated UID if valid, null if unauthorized
 */
export declare function requireAuth(request: AuthRequest, response: TypedResponse): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map