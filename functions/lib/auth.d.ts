export interface TypedRequest {
    method: string;
    headers: {
        authorization?: string;
        [key: string]: string | string[] | undefined;
    };
    body: unknown;
}
export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (body: unknown) => TypedResponse;
    send: (body: unknown) => TypedResponse;
}
export declare const requireAuth: (req: TypedRequest, res: TypedResponse) => Promise<boolean>;
//# sourceMappingURL=auth.d.ts.map