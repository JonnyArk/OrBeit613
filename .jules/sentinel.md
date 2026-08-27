## 2026-08-27 - Missing Authentication on onRequest Endpoints
**Vulnerability:** Firebase Cloud Functions (v2) `onRequest` endpoints do not automatically enforce authentication, leaving sensitive AI endpoints exposed to unauthorized access.
**Learning:** In Firebase v2, HTTP endpoints created with `onRequest` are public by default. Relying on them for sensitive operations without manual token verification allows unauthorized usage.
**Prevention:** Always manually extract the `Authorization` header and verify the bearer token using `getAuth().verifyIdToken()` from `firebase-admin/auth` for any `onRequest` endpoint handling sensitive data or costly operations.
