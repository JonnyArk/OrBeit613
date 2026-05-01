export type TypedResponse = {
    json: (data: unknown) => void;
    status: (code: number) => TypedResponse;
    send: (data: string) => void;
};
export declare function requireAuth(request: {
    headers: {
        authorization?: string;
    };
}, response: TypedResponse): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map