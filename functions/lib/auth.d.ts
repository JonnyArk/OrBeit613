export interface TypedRequest {
    headers: Record<string, string | string[] | undefined>;
    method: string;
}
export interface TypedResponse {
    status(code: number): this;
    json(data: unknown): this;
    send(data: unknown): this;
}
export interface AuthContext {
    uid: string;
}
/**
 * Verifies the Firebase ID token in the Authorization header.
 * Allows OPTIONS requests to pass through for CORS.
 *
 * @param request - The incoming HTTP request
 * @param response - The HTTP response
 * @returns AuthContext if successful, null otherwise
 */
export declare function requireAuth(request: TypedRequest, response: TypedResponse): Promise<AuthContext | null>;
//# sourceMappingURL=auth.d.ts.map