/**
 * Structural type for Express response to avoid @types/express dependency
 */
export type TypedResponse = {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (body: unknown) => void;
};
/**
 * Verifies Firebase ID token from Authorization header.
 *
 * @param request - HTTP request object with headers
 * @returns Promise resolving to the authenticated user's UID
 * @throws Error if authentication fails
 */
export declare function requireAuth(request: {
    headers: {
        authorization?: string;
    };
}): Promise<string>;
//# sourceMappingURL=auth.d.ts.map