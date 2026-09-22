## 2025-02-12 - Missing Authentication on Cloud Functions v2 onRequest Endpoints
**Vulnerability:** The `generateAsset` and `distillContext` endpoints lacked built-in authentication context, allowing any anonymous user to call them and consume AI credits (a severe financial and security risk).
**Learning:** In Firebase Cloud Functions v2, `onRequest` HTTP endpoints do not automatically extract and verify user authentication tokens like `onCall` endpoints do. This must be manually performed using `getAuth().verifyIdToken()`.
**Prevention:** Always manually extract the Bearer token from `request.headers.authorization` and verify it using Firebase Admin Auth for any sensitive `onRequest` HTTP endpoint. Consider using `onCall` if automatic authentication context is preferred.
