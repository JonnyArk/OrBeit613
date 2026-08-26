## 2026-08-26 - Enforce Authentication on Cloud Functions (v2) `onRequest`
**Vulnerability:** Firebase Cloud Functions (v2) `onRequest` endpoints do not enforce authentication automatically. They were publicly accessible, allowing unauthorized AI credit consumption and potentially IDOR.
**Learning:** I must manually extract the `Authorization` header and verify the bearer token using `getAuth().verifyIdToken()` on `onRequest` endpoints.
**Prevention:** Always implement explicit token verification and overwrite any client-provided `userId` with the verified `authUserId` to prevent IDOR.
