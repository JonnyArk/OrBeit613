## 2025-02-14 - Missing Authentication on Firebase v2 onRequest Endpoints
**Vulnerability:** Sensitive REST API endpoints (`creditUsage`, `generateAsset`, `distillContext`) lacked authentication and could be invoked by anyone.
**Learning:** Firebase Cloud Functions v2 `onRequest` endpoints default to public access, unlike `onCall` which provides managed context. Express-based token verification must be explicitly implemented.
**Prevention:** Always implement explicit token validation using `getAuth().verifyIdToken()` on `onRequest` endpoints that handle sensitive operations or AI credit consumption.
