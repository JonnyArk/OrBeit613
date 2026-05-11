export interface RequestWithAuth {
    headers: {
        authorization?: string;
    };
}
export interface TypedResponse {
    status: (code: number) => TypedResponse;
    json: (data: unknown) => void;
}
/**
 * Verifies the Firebase ID token in the Authorization header.
 *
 * @param req - The HTTP request object.
 * @param res - The HTTP response object.
 * @returns The user's UID if authenticated, or null if unauthorized.
 */
export declare function requireAuth(req: RequestWithAuth, res: TypedResponse): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map