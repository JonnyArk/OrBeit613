## 2026-08-24 - Fix Missing Auth in v2 onRequest Endpoints
**Vulnerability:** Missing authentication on the `generateAsset` and `distillContext` v2 `onRequest` endpoints.
**Learning:** In Firebase Cloud Functions v2, `onRequest` endpoints do not automatically enforce authentication. This codebase relies on `onRequest` endpoints which allowed unauthorized access.
**Prevention:** When using `onRequest` in v2, always manually extract the `Authorization` header and verify the bearer token via `getAuth().verifyIdToken()`.
