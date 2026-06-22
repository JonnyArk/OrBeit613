## 2024-06-22 - Add authentication to AI processing endpoints
**Vulnerability:** The `generateAsset` and `distillContext` Cloud Functions lacked authentication, allowing unauthorized access to AI capabilities.
**Learning:** Firebase `onRequest` endpoints accessed via a web client require custom authentication and preflight CORS handling. Just wrapping with `requireAuth` without a CORS handler leads to 401 Unauthorized for preflight `OPTIONS` requests.
**Prevention:** Whenever securing an `onRequest` HTTP function accessed from browsers, wrap the endpoint logic inside a `cors` middleware callback before verifying the authorization token.
