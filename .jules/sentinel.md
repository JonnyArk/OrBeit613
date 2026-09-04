## 2026-09-04 - Secure Firebase v2 onRequest Endpoints
**Vulnerability:** Firebase v2 `onRequest` endpoints do not automatically enforce authentication, allowing unauthorized users to invoke them and potentially exhaust resources like AI credits.
**Learning:** `onRequest` functions expose a public HTTP endpoint by default. Unlike `onCall` functions, they require manual extraction and verification of the `Authorization` header to secure them.
**Prevention:** Always use `firebase-admin/auth` with `getAuth().verifyIdToken()` to manually verify caller identity on sensitive `onRequest` endpoints.
