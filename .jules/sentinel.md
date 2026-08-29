## 2026-08-29 - Unauthenticated Firebase HTTP Functions
**Vulnerability:** Firebase v2 `onRequest` Cloud Functions (`generateAsset`) lacked manual authentication checks, exposing AI credit-consuming endpoints to the public internet.
**Learning:** Firebase `onRequest` endpoints do not automatically enforce authentication like callable functions do.
**Prevention:** Always manually extract the `Authorization` header and verify the bearer token using `getAuth().verifyIdToken()` in `onRequest` handlers for sensitive endpoints.
