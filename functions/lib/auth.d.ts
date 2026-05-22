export interface TypedRequest {
    method: string;
    headers: {
        authorization?: string;
        [key: string]: string | string[] | undefined;
    };
    body: unknown;
    query: Record<string, unknown>;
}
export interface TypedResponse {
    status(code: number): this;
    json(data: unknown): this;
    send(data: string): this;
    set(field: string, value: string): this;
}
export declare function requireAuth(req: TypedRequest, res: TypedResponse): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map