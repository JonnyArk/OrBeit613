## 2024-08-09 - Missing Authentication on onRequest Endpoints
**Vulnerability:** Firebase Cloud Functions `onRequest` endpoints (`creditUsage`, `generateAsset`, `distillContext`) lack authentication checks, allowing unauthorized access.
**Learning:** Unlike `onCall` endpoints which handle auth natively, `onRequest` REST endpoints require manual token validation.
**Prevention:** For `onRequest` endpoints, explicitly extract the token from `request.headers.authorization` and verify it using `getAuth().verifyIdToken(token)` from `firebase-admin/auth`.
