## 2025-02-05 - Missing Authentication on Cloud Functions v2 onRequest Endpoints
**Vulnerability:** Firebase Functions v2 `onRequest` HTTP endpoints (`generateAsset`, `distillContext`, `creditUsage`) lacked authentication, exposing costly AI functionalities to public access.
**Learning:** Unlike `onCall` functions, `onRequest` endpoints do not have built-in authentication context. This represents a surprising architectural gap that requires explicit validation.
**Prevention:** Always manually extract the Bearer token from `request.headers.authorization` and verify it using `getAuth().verifyIdToken()` from `firebase-admin/auth` for any `onRequest` endpoints.
