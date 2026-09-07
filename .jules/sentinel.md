## 2024-09-07 - Missing Authentication on Costly Cloud Functions
**Vulnerability:** The v2 `onRequest` Cloud Functions (`generateAsset` and `distillContext`) did not enforce authentication, exposing the API to unauthenticated usage and potential denial-of-wallet attacks since they use AI services that cost credits.
**Learning:** In Firebase Cloud Functions v2, `onRequest` endpoints do not automatically enforce authentication.
**Prevention:** Always manually extract the `Authorization` header and verify the bearer token using `getAuth().verifyIdToken()` from `firebase-admin/auth` for `onRequest` endpoints that perform sensitive or costly actions. Additionally, enforce the user identity extracted from the token to prevent IDOR.
