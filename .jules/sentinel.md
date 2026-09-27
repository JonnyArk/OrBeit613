## 2025-02-05 - Missing Authentication on onRequest HTTP Endpoints
**Vulnerability:** Firebase Cloud Functions v2 `onRequest` HTTP endpoints lacked authentication and authorization checks, allowing unauthenticated or unauthorized execution of AI services (`generateAsset` and `distillContext`).
**Learning:** `onRequest` functions do not inherently verify authentication like `onCall` functions do. Client-provided user IDs in payloads must never be trusted; they can be easily manipulated (IDOR).
**Prevention:** Always manually extract the Bearer token from the `Authorization` header, verify it using `getAuth().verifyIdToken()`, and enforce identity by strictly overwriting any payload `userId` with the verified `decodedToken.uid`.
