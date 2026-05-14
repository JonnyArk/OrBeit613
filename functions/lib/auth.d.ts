export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (data: unknown) => void;
}
export declare const requireAuth: (request: {
    headers: {
        authorization?: string;
    };
}, response: TypedResponse) => Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map