export interface TypedRequest {
    method: string;
    headers: {
        authorization?: string;
        [key: string]: string | string[] | undefined;
    };
    body: unknown;
}
export interface TypedResponse {
    status(code: number): TypedResponse;
    json(data: unknown): void;
    end(): void;
    set(field: string, value: string): TypedResponse;
}
/**
 * Verifies the Firebase ID token in the Authorization header.
 * Allows OPTIONS requests for CORS preflight.
 */
export declare function requireAuth(request: TypedRequest, response: TypedResponse): Promise<boolean>;
//# sourceMappingURL=auth.d.ts.map