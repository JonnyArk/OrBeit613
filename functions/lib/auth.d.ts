export interface TypedRequest {
    method: string;
    headers: {
        authorization?: string;
        [key: string]: string | string[] | undefined;
    };
    body: unknown;
}
export interface TypedResponse {
    status(code: number): this;
    json(data: unknown): this;
    send(data?: unknown): this;
}
/**
 * Validates the Firebase ID token in the authorization header.
 *
 * @param request The incoming HTTP request
 * @param response The HTTP response object
 * @returns A promise that resolves to true if authorized, false otherwise
 */
export declare function requireAuth(request: TypedRequest, response: TypedResponse): Promise<boolean>;
//# sourceMappingURL=auth.d.ts.map