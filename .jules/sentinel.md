## 2025-05-24 - Unauthenticated Firebase Cloud Functions v2
**Vulnerability:** Firebase Cloud Functions v2 `onRequest` endpoints (`creditUsage`, `generateAsset`, `distillContext`) lacked authentication checks, allowing public execution and potential abuse of credits and AI resources.
**Learning:** Unlike `onCall` functions, `onRequest` endpoints in v2 do not automatically pass or verify Firebase Auth context, leaving them publicly accessible by default.
**Prevention:** Always manually extract and verify the Bearer token using `getAuth().verifyIdToken()` on `onRequest` endpoints containing sensitive or costly logic. Leave `healthCheck` unauthenticated for monitoring.
