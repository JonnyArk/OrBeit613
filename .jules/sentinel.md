## 2025-02-14 - Missing Authentication in Cloud Functions onRequest Endpoints
**Vulnerability:** The `onRequest` Cloud Functions in Firebase v2 (`creditUsage`, `generateAsset`, `distillContext`) lacked built-in authentication, allowing unauthenticated public access.
**Learning:** Unlike `onCall` functions which automatically handle Firebase Authentication, `onRequest` functions expose raw HTTP endpoints and require manual extraction and verification of Bearer tokens using `getAuth().verifyIdToken()`.
**Prevention:** Always implement manual token verification with `getAuth().verifyIdToken()` wrapped in a `try...catch` block (returning a standard 401 response) for any sensitive `onRequest` HTTP endpoints in Firebase to prevent unauthorized access to backend resources and APIs.
