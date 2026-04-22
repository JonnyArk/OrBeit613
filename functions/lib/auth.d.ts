export type TypedResponse = {
    status: (code: number) => {
        json: (data: unknown) => void;
    };
    json: (data: unknown) => void;
};
export declare function requireAuth(request: {
    headers: {
        authorization?: string;
    };
}, response: TypedResponse): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map