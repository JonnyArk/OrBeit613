export interface TypedRequest {
    method: string;
    headers: Record<string, string | string[] | undefined>;
}
export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (body?: unknown) => void;
    end: () => void;
}
export declare function requireAuth(req: TypedRequest, res: TypedResponse): Promise<boolean>;
//# sourceMappingURL=auth.d.ts.map