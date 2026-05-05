export interface AuthRequest {
    headers: {
        authorization?: string;
    };
}
export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
}
/**
 * Validates the Authorization header and returns the authenticated user's ID.
 * @param request The HTTP request object.
 * @returns The authenticated user's UID.
 * @throws Error if authentication fails.
 */
export declare function requireAuth(request: AuthRequest): Promise<string>;
//# sourceMappingURL=auth.d.ts.map