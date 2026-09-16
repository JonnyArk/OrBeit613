## 2024-05-24 - Missing Authentication on Cloud Functions v2 onRequest Endpoints
**Vulnerability:** The HTTP endpoints (`creditUsage`, `generateAsset`, `distillContext`) in `functions/src/index.ts` lack authentication checks, allowing unauthenticated access to sensitive data and operations.
**Learning:** Firebase Cloud Functions v2 `onRequest` endpoints do not have built-in authentication context like `onCall`. Authentication must be manually implemented by verifying the Bearer token from the `Authorization` header.
**Prevention:** Always implement explicit token verification using `getAuth().verifyIdToken()` for any sensitive `onRequest` endpoints.
