## 2026-08-23 - Missing Authentication on Cloud Functions
**Vulnerability:** Firebase v2 `onRequest` endpoints (`generateAsset`, `distillContext`, `creditUsage`) were completely unauthenticated, allowing any anonymous user to trigger AI generation, exhaust the monthly credit limits, and view credit usage.
**Learning:** `onRequest` functions in Firebase v2 do not automatically enforce authentication unlike `onCall`.
**Prevention:** Always manually extract the `Authorization` header and verify the bearer token using `getAuth().verifyIdToken()` for any `onRequest` endpoints handling sensitive operations.
