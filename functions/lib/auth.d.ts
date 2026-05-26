import type { DecodedIdToken } from "firebase-admin/auth";
export interface TypedRequest {
    method: string;
    headers: {
        authorization?: string;
        [key: string]: string | string[] | undefined;
    };
    body: unknown;
}
export interface TypedResponse {
    status(code: number): TypedResponse;
    json(data: unknown): void;
    send(body: string): void;
    set(field: string, value: string): void;
}
/**
 * Validates the Firebase ID token in the Authorization header.
 * Allows OPTIONS requests for CORS preflight.
 *
 * @param request The incoming HTTP request
 * @param response The HTTP response
 * @returns The decoded token if valid, true if OPTIONS request, or null if invalid
 */
export declare function requireAuth(request: unknown, response: unknown): Promise<DecodedIdToken | boolean | null>;
//# sourceMappingURL=auth.d.ts.map