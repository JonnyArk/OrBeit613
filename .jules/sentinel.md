## 2024-05-06 - Missing Authentication on HTTP Endpoints
**Vulnerability:** The `generateAsset` and `distillContext` Firebase Cloud Functions were exposed publicly without authentication, allowing unauthorized users to execute AI tasks and consume system credits.
**Learning:** Unlike Callable functions, Firebase v2 `onRequest` functions are public by default and do not automatically enforce authentication checks.
**Prevention:** Always manually implement explicit authentication checks (e.g., using `getAuth().verifyIdToken()` via the `requireAuth` helper) on sensitive `onRequest` endpoints to prevent unauthorized access.
