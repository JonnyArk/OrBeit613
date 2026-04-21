export type TypedResponse = {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
};
export type TypedRequest = {
    headers: {
        authorization?: string;
    };
    body: unknown;
    method: string;
};
export declare function requireAuth(req: TypedRequest, res: TypedResponse): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map