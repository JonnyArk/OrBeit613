## 2024-10-13 - [Unauthorized AI Credit Usage in Cloud Functions]
**Vulnerability:** Firebase Cloud Functions v2 `onRequest` endpoints (`creditUsage`, `generateAsset`, `distillContext`) lacked manual authentication, allowing unauthenticated public invocation.
**Learning:** `onRequest` functions in v2 do not automatically provide `request.auth` context like `onCall` functions. Manual Bearer token extraction and verification are required.
**Prevention:** Always manually authenticate `onRequest` endpoints using `getAuth().verifyIdToken()` from `firebase-admin/auth` wrapped in a try/catch, returning 401 on failure.
