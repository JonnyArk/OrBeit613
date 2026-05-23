## 2026-05-23 - Securing Cloud Functions Endpoints
**Vulnerability:** Unauthenticated `onRequest` Firebase Cloud Functions allowed public access to `creditUsage`, `generateAsset`, and `distillContext`, potentially exposing sensitive data and incurring unwanted AI credits usage.
**Learning:** `onRequest` endpoints do not automatically verify authentication. CORS preflight `OPTIONS` requests also need to be explicitly allowed without authentication.
**Prevention:** Always use an explicit authentication check like `requireAuth` inside `onRequest` handlers to protect them, or use `onCall` which natively handles authentication and CORS.
