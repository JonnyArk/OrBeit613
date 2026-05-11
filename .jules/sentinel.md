
## 2026-05-11 - Enforce Authentication on Firebase v2 HTTP Endpoints
**Vulnerability:** Public, unauthenticated access to sensitive Cloud Functions (`generateAsset`, `distillContext`, `creditUsage`) exposed the system to AI credit drain, resource exhaustion, and data leakage.
**Learning:** Firebase v2 `onRequest` functions are public by default and do not automatically inherit authentication context, unlike Callable functions.
**Prevention:** Always manually implement explicit authentication checks (e.g., using `getAuth().verifyIdToken()`) at the start of any `onRequest` function that handles sensitive data or consumes resources.
