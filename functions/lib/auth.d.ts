export interface TypedRequest {
    method: string;
    headers: {
        authorization?: string;
        [key: string]: unknown;
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
 * Helper to require authentication for onRequest endpoints.
 * Automatically handles CORS preflight requests.
 */
export declare function requireAuth(req: TypedRequest, res: TypedResponse): Promise<{
    uid: string;
} | null>;
//# sourceMappingURL=auth.d.ts.map