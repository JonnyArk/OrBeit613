import { DecodedIdToken } from "firebase-admin/auth";
export interface TypedRequest {
    headers: Record<string, string | string[] | undefined>;
    body: unknown;
    method: string;
}
export interface TypedResponse {
    status(code: number): TypedResponse;
    json(data: unknown): TypedResponse;
    send(data: unknown): TypedResponse;
}
/**
 * Verifies the Firebase ID token in the Authorization header.
 * Returns the decoded token if valid, or null if invalid/missing.
 * If invalid, it automatically sends a 401 response.
 */
export declare function requireAuth(req: TypedRequest, res: TypedResponse): Promise<DecodedIdToken | null>;
//# sourceMappingURL=auth.d.ts.map