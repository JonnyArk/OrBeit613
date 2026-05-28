export interface TypedRequest {
    method: string;
    headers: {
        authorization?: string;
        origin?: string;
        [key: string]: string | string[] | undefined;
    };
    body: unknown;
}
export interface TypedResponse {
    status(code: number): this;
    json(body: unknown): void;
    set(field: string, value: string): this;
}
export declare function requireAuth(req: unknown, res: unknown): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map