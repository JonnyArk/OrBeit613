## 2026-05-14 - Firebase v2 onRequest Missing Default Authentication
**Vulnerability:** The `generateAsset` and `distillContext` HTTP endpoints using Firebase Functions v2 `onRequest` were public and unauthenticated, allowing unauthorized access to AI capabilities.
**Learning:** Unlike Callable functions, Firebase v2 `onRequest` functions are public by default and do not automatically enforce authentication.
**Prevention:** Always manually implement explicit authentication checks (e.g., using `getAuth().verifyIdToken()` or `requireAuth`) on sensitive `onRequest` endpoints.
