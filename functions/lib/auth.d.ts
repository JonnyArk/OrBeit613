export interface TypedResponse {
    status(code: number): TypedResponse;
    json(data: unknown): void;
}
export interface RequestWithAuth {
    headers: {
        authorization?: string;
    };
}
/**
 * Validates the Authorization header and verifies the Firebase ID token.
 * Returns the user ID if successful, otherwise sends a 401 response and returns null.
 */
export declare function requireAuth(request: RequestWithAuth, response: TypedResponse): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map