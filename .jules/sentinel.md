# Sentinel's Journal 🛡️

## 2025-05-15 - Unauthenticated AI Endpoints via `onRequest`
**Vulnerability:** Cloud Functions (`generateAsset`, `distillContext`) were exposed as public HTTP endpoints (`onRequest`) without any authentication checks, allowing anyone to consume paid AI quotas.
**Learning:** The codebase used `httpsCallable` on the client but `onRequest` on the server, creating a mismatch that bypassed standard Firebase Auth verification. This likely happened due to a misunderstanding of how `httpsCallable` interacts with server-side function definitions.
**Prevention:** Always implement client-callable backend logic using `onCall`, which automatically enforces authentication token verification. For any `onRequest` function, explicitly add middleware or checks for `request.auth` if it handles sensitive data or operations.
