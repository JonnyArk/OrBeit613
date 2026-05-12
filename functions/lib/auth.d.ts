export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (data: unknown) => void;
}
export interface AuthRequest {
    headers: {
        authorization?: string;
        [key: string]: string | string[] | undefined;
    };
}
/**
 * Validates the Firebase ID token from the Authorization header.
 *
 * @param request - The HTTP request object containing headers
 * @returns The decoded UID if valid, or null if unauthorized
 */
export declare function requireAuth(request: AuthRequest): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map