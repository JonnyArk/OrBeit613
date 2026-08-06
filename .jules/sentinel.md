## YYYY-MM-DD - Missing Authentication on Firebase `onRequest` Functions
**Vulnerability:** The AI API endpoints (`generateAsset` and `distillContext`) built with `onRequest` did not have authentication checks, allowing public unauthenticated access to consume AI credits.
**Learning:** Unlike `onCall` functions which automatically handle and provide user auth context, `onRequest` REST endpoints in Firebase Cloud Functions do not implicitly verify user auth tokens.
**Prevention:** When using `onRequest`, explicit token validation must be implemented by extracting the token from the `Authorization` header and verifying it via `getAuth().verifyIdToken()`.
