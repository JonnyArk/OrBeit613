## 2026-10-15 - Missing Authentication on Cloud Functions
**Vulnerability:** The `creditUsage`, `generateAsset`, and `distillContext` functions in Firebase Cloud Functions v2 use `onRequest` endpoints which do not have built-in authentication context.
**Learning:** In Firebase Cloud Functions v2, `onRequest` endpoints are entirely public by default unless specifically secured. Unlike `onCall` functions, they don't automatically provide auth context.
**Prevention:** To secure `onRequest` endpoints, always manually extract the Bearer token from `request.headers.authorization` and verify it using `getAuth().verifyIdToken()` from `firebase-admin/auth`. Wrap the verification in a try/catch block and return a 401 response on failure.
