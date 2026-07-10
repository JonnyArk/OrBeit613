## 2026-02-05 - Missing Authentication on Cloud Functions
**Vulnerability:** The `generateAsset` and `distillContext` HTTP endpoints lacked authentication and CORS headers, allowing unauthenticated attackers to trigger expensive AI operations and spoof the `userId` in the payload.
**Learning:** `onRequest` HTTP functions bypass Firebase Security Rules and must implement manual authentication checks (token verification) and CORS wrapping to protect resources and ensure identity authenticity.
**Prevention:** Always wrap `onRequest` functions accessed by browsers with `cors` middleware, verify the `Bearer` token inside the wrapper, use an async `try/catch` to handle rejected promises, and extract the `userId` directly from the decoded token rather than trusting the client payload.
