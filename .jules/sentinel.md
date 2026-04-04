## 2024-04-04 - Missing Authentication on HTTP Endpoints
**Vulnerability:** AI endpoints `generateAsset` and `distillContext` lacked authentication, trusting client-provided `userId` and allowing unauthorized credit consumption.
**Learning:** In Firebase, standard `onRequest` endpoints do not automatically verify user auth like `onCall` functions do.
**Prevention:** Always manually verify `Authorization` headers via `getAuth().verifyIdToken()` for `onRequest` endpoints and override client payload `userId` with the trusted `uid`.
