
## 2024-05-24 - Add authentication to Cloud Functions v2 HTTP endpoints
**Vulnerability:** Missing authentication on sensitive AI and credit usage endpoints.
**Learning:** Firebase Cloud Functions v2 `onRequest` HTTP endpoints lack the built-in authentication context provided by `onCall`.
**Prevention:** Manually extract the Bearer token from `request.headers.authorization` and verify it using `getAuth().verifyIdToken()` from `firebase-admin/auth` for `onRequest` endpoints.
