## 2025-02-05 - Added Auth to AI Resource Endpoints
**Vulnerability:** The `generateAsset` and `distillContext` endpoints in Firebase `onRequest` were public by default and allowed unauthenticated access to consume valuable AI credits.
**Learning:** Unlike Firebase v1 Callable functions, Firebase v2 `onRequest` functions are public by default and require manual validation of ID tokens (e.g., via `requireAuth`) on sensitive endpoints.
**Prevention:** Always implement explicit authentication checks (like using `getAuth().verifyIdToken()`) and inject authenticated user IDs securely on `onRequest` endpoints handling sensitive tasks or resources.
