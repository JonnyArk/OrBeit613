export interface TypedResponse {
    status(code: number): TypedResponse;
    json(data: unknown): void;
    send(data: string): void;
    end(): void;
}
export interface TypedRequest {
    headers: Record<string, string | string[] | undefined>;
    method: string;
}
export declare function requireAuth(req: unknown, res: unknown): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map