## 2026-09-02 - Enforce Authentication on Firebase v2 HTTP Functions
**Vulnerability:** Missing authentication on sensitive `onRequest` AI endpoints (`generateAsset`, `distillContext`), allowing unauthorized usage and potential IDOR via client-provided `userId`.
**Learning:** Firebase Cloud Functions v2 `onRequest` endpoints do not automatically enforce authentication like `onCall` functions do. Client-provided user IDs in the request body can be easily spoofed if not validated against the auth token.
**Prevention:** Manually extract and verify the `Authorization` bearer token using `getAuth().verifyIdToken()`. Always override payload user IDs with the verified `decodedToken.uid`.
