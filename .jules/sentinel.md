## 2025-02-14 - Authorization bypass in AI endpoints
**Vulnerability:** HTTP endpoints `creditUsage`, `generateAsset`, and `distillContext` lacked authentication, allowing unauthorized users to hit them. Also, `generateAsset` and `distillContext` accepted `userId` from the request body, allowing IDOR/spoofing of generated AI resources, while `healthCheck` leaked credit usage data.
**Learning:** Functions exposed via `onRequest` don't automatically populate `request.auth` like `onCall` functions do. We must manually check the authorization header.
**Prevention:** Use `getAuth().verifyIdToken(token)` to verify the bearer token, and use the extracted `uid` to overwrite any `userId` passed in the body, preventing spoofing. Ensure health checks don't leak business-sensitive data.
