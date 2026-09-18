## 2024-05-24 - Missing Authentication on Cloud Functions v2 onRequest Endpoints
**Vulnerability:** Found `onRequest` HTTP functions (`generateAsset`, `distillContext`) in `functions/src/index.ts` that were completely public with no authentication checks, exposing sensitive AI endpoints and consuming credits indiscriminately.
**Learning:** In Firebase Cloud Functions v2, `onRequest` endpoints lack the built-in authentication context provided by `onCall`. Developers must manually extract and verify the Bearer token.
**Prevention:** Always manually extract `request.headers.authorization` and verify the token using `getAuth().verifyIdToken()` for any `onRequest` endpoints that require user context. Consider using `onCall` instead if raw HTTP handling is not strictly required.
