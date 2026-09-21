## 2024-05-28 - Missing Authentication and IDOR on AI Endpoints
**Vulnerability:** The `generateAsset` and `distillContext` Cloud Functions endpoints using `onRequest` lacked any authentication context and accepted a client-provided `userId` from the request body, which can be manipulated.
**Learning:** `onRequest` HTTP functions in Firebase Cloud Functions v2 do not automatically provide an authentication context like `onCall` functions do. Client-provided `userId` must never be trusted.
**Prevention:** Always manually extract the Bearer token, verify it with `getAuth().verifyIdToken()`, and strictly override the payload's user ID with the verified identity.
