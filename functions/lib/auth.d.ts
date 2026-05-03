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
 * Validates Authorization header and returns authenticated user's ID.
 */
export declare function requireAuth(req: TypedRequest): Promise<string>;
//# sourceMappingURL=auth.d.ts.map