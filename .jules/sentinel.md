## 2026-08-30 - Missing Authentication on v2 onRequest Endpoints
**Vulnerability:** Firebase Cloud Functions v2 `onRequest` endpoints (like `generateAsset` and `distillContext`) were exposed publicly without authentication, allowing anyone to drain AI credits.
**Learning:** Unlike callable functions (`onCall`), v2 `onRequest` HTTP endpoints do not automatically enforce or verify Firebase Authentication.
**Prevention:** Always manually extract the `Authorization` header and verify the bearer token using `getAuth().verifyIdToken()` in `onRequest` functions that perform sensitive operations.
