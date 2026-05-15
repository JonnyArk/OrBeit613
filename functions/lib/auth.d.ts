export interface TypedResponse {
    status(code: number): TypedResponse;
    json(data: unknown): void;
}
export interface AuthRequest {
    headers: {
        authorization?: string;
    };
}
/**
 * Verifies the Firebase ID token in the Authorization header.
 * Returns the UID if successful, or null if unauthorized (and sends 401 response).
 */
export declare function requireAuth(request: AuthRequest, response: TypedResponse): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map