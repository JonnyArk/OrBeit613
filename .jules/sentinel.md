## 2025-02-12 - Missing Authentication on Firebase v2 onRequest Endpoints
**Vulnerability:** The `generateAsset`, `distillContext`, and `creditUsage` endpoints in `functions/src/index.ts` were unauthenticated, allowing any external user to invoke expensive AI endpoints and leak usage data.
**Learning:** In Firebase Cloud Functions v2, `onRequest` endpoints do not provide built-in authentication context unlike `onCall`. As a result, sensitive endpoints were exposed publicly.
**Prevention:** Always manually extract the Bearer token from `request.headers.authorization` and verify it using `getAuth().verifyIdToken()` from `firebase-admin/auth` for all sensitive `onRequest` endpoints.
