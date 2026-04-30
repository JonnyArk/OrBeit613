export interface TypedRequest {
    headers: {
        authorization?: string;
        [key: string]: string | string[] | undefined;
    };
    body?: unknown;
    method?: string;
}
export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
    send: (data: unknown) => void;
}
/**
 * Requires a valid Firebase ID token in the Authorization header.
 * @returns the decoded user ID if authenticated, or null if unauthorized.
 */
export declare function requireAuth(req: TypedRequest, res: TypedResponse): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map