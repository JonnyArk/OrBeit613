## 2026-02-05 - Add Authentication to Firebase Cloud Functions (v2) onRequest Endpoints
**Vulnerability:** Unauthenticated access was permitted on Cloud Functions (v2) `onRequest` endpoints (`creditUsage`, `generateAsset`, `distillContext`).
**Learning:** In Firebase Cloud Functions v2, `onRequest` HTTP endpoints do not have built-in authentication context unlike `onCall` functions. The token must be manually verified using `getAuth().verifyIdToken()`. `healthCheck` endpoints are designed to be unauthenticated for monitoring.
**Prevention:** For `onRequest` functions containing sensitive operations, manually extract and verify the Bearer token and wrap the process in a `try...catch` block to securely return a `401 Unauthorized`.
