## 2025-05-08 - Public Firebase v2 onRequest Functions
**Vulnerability:** Sensitive endpoints (`creditUsage`, `generateAsset`, `distillContext`) were exposed publicly without authentication checks.
**Learning:** Unlike Callable functions, Firebase v2 `onRequest` functions are public by default and do not automatically enforce authentication.
**Prevention:** Always manually implement explicit authentication checks (e.g., using `getAuth().verifyIdToken()`) on sensitive `onRequest` endpoints to prevent unauthorized access.
