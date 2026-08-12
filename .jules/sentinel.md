## 2024-05-20 - Unauthenticated AI Endpoints
**Vulnerability:** Missing authentication on `onRequest` endpoints for sensitive AI services (`generateAsset`, `distillContext`, `creditUsage`).
**Learning:** In Firebase v2, `onRequest` endpoints do not automatically verify auth tokens like `onCall` does.
**Prevention:** Explicitly validate `request.headers.authorization` using `getAuth().verifyIdToken(token)` for all `onRequest` endpoints that require authentication.
