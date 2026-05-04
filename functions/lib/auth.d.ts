export interface TypedRequest {
    headers: {
        authorization?: string;
    };
    body: unknown;
    method: string;
}
export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
}
export declare function requireAuth(request: TypedRequest, response: TypedResponse): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map