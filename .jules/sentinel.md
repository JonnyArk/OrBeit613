## 2026-06-02 - Securing onRequest endpoints
**Vulnerability:** Unauthenticated access to sensitive Firebase Cloud Functions (`creditUsage`, `generateAsset`, `distillContext`).
**Learning:** The `onRequest` handler in Firebase Functions v2 does not automatically enforce authentication. This must be manually implemented to prevent unauthorized access and potential resource abuse.
**Prevention:** Always implement an authentication check (e.g., verifying Firebase ID tokens) in `onRequest` functions before processing requests, and remember to handle CORS `OPTIONS` preflight requests properly so they don't fail authentication.
