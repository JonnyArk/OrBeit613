## 2026-05-19 - Missing Authentication on HTTP Endpoints
**Vulnerability:** Firebase onRequest endpoints (generateAsset, distillContext) lacked authentication, allowing unauthenticated public access to sensitive AI generation endpoints.
**Learning:** Unlike onCall functions, onRequest functions in Firebase do not automatically verify authentication tokens.
**Prevention:** Always use a custom auth middleware or helper (like requireAuth) to manually verify Firebase ID tokens on onRequest endpoints that perform sensitive operations.
