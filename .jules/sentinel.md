## 2026-09-03 - Firebase v2 onRequest Authentication
**Vulnerability:** Missing authentication on sensitive Firebase v2 Cloud Functions endpoints (generateAsset, distillContext, creditUsage).
**Learning:** Firebase v2 `onRequest` endpoints do not automatically enforce authentication. They act as public webhooks by default, leaving sensitive operations and AI resource usage vulnerable to unauthorized access.
**Prevention:** Always manually extract the `Authorization` header and verify the bearer token using `getAuth().verifyIdToken()` for any secure `onRequest` endpoint.
