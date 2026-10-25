## 2024-10-25 - Firebase v2 onRequest Authentication Gap
**Vulnerability:** Unauthenticated access to sensitive endpoints (`creditUsage`, `generateAsset`, `distillContext`).
**Learning:** Firebase v2 `onRequest` functions lack built-in auth context unlike `onCall`, requiring manual Bearer token verification.
**Prevention:** Always manually extract and verify `request.headers.authorization` using `getAuth().verifyIdToken()` in a try/catch block returning 401 for non-public `onRequest` endpoints.
