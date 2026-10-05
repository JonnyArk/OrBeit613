## 2025-03-09 - Missing Authentication on HTTP Endpoints
**Vulnerability:** The `generateAsset` and `distillContext` `onRequest` Cloud Functions were missing authentication checks.
**Learning:** In Firebase Cloud Functions v2, `onRequest` endpoints do not have built-in authentication context like `onCall` functions, meaning they must be manually authenticated.
**Prevention:** Always verify `request.headers.authorization` manually via `getAuth().verifyIdToken()` in `onRequest` functions and strictly overwrite the `userId` in payloads to prevent IDOR.
