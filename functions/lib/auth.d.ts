export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (data: unknown) => void;
}
export interface AuthContext {
    uid: string;
}
export declare function requireAuth(request: {
    headers: {
        authorization?: string;
    };
}, response: TypedResponse): Promise<AuthContext | null>;
//# sourceMappingURL=auth.d.ts.map