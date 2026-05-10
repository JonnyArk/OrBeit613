export interface TypedRequest {
    headers: {
        authorization?: string;
    };
    [key: string]: unknown;
}
export interface TypedResponse {
    status: (code: number) => this;
    json: (data: unknown) => void;
    [key: string]: unknown;
}
/**
 * Validates the Firebase ID token in the authorization header.
 * Returns the decoded token if valid, or null if invalid.
 * If invalid, it also sends the appropriate 401 response.
 */
export declare function requireAuth(req: TypedRequest, res: TypedResponse): Promise<unknown | null>;
//# sourceMappingURL=auth.d.ts.map