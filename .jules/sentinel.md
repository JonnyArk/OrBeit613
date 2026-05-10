## 2025-02-12 - Missing Auth on Firebase v2 HTTP Functions
**Vulnerability:** Cost-incurring and sensitive Cloud Functions (`generateAsset`, `distillContext`, `creditUsage`) were publicly accessible without any authentication.
**Learning:** Unlike Firebase Callable functions, `onRequest` HTTP functions in Firebase v2 are public by default and do not automatically enforce authentication.
**Prevention:** Always manually implement explicit authentication checks (e.g., using `getAuth().verifyIdToken()`) on sensitive endpoints. Always return generic HTTP error responses (e.g., "Internal Server Error") to avoid leaking sensitive internal details like error messages.
