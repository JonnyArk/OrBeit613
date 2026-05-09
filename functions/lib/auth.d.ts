export interface TypedResponse {
    status(code: number): this;
    json(data: unknown): void;
}
export declare function requireAuth(request: {
    headers: {
        authorization?: string;
    };
}, response: TypedResponse): Promise<boolean>;
//# sourceMappingURL=auth.d.ts.map