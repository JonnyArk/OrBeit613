## 2025-02-05 - Firebase Cloud Functions v2 onRequest Authentication Bypass and IDOR

**Vulnerability:**
The HTTP endpoints (`generateAsset`, `distillContext`, `creditUsage`) deployed via Firebase Cloud Functions v2 `onRequest` lacked any authentication checks. Furthermore, endpoints accepting payloads (`generateAsset`, `distillContext`) inherently trusted the client-provided `userId`, resulting in an Insecure Direct Object Reference (IDOR) vulnerability.

**Learning:**
Unlike Firebase Cloud Functions `onCall` which automatically handles and verifies the authentication context and prevents spoofing the user ID, `onRequest` endpoints are raw HTTP handlers. They require manual extraction and verification of the Bearer token from the `Authorization` header. Attempting to use `onRequest` without implementing explicit validation exposes the endpoints to unauthorized access, and trusting payload parameters for identity exposes the system to IDOR.

**Prevention:**
1. Manually implement Bearer token extraction and verification using `getAuth().verifyIdToken()` within `onRequest` handlers.
2. Never trust client-provided user IDs (e.g., `body.userId`) for operations. Always overwrite such parameters with the verified identity extracted from the server-side token.
