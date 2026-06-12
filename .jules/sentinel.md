## 2025-06-12 - Missing Authentication on Cloud Functions
**Vulnerability:** Found multiple sensitive endpoints (creditUsage, generateAsset, distillContext) exposed via `onRequest` without any authentication checks, allowing anonymous access to premium AI APIs and credit usage data.
**Learning:** Functions exported with `onRequest` are inherently public unless manually guarded. They do not automatically inherit Firebase Security Rules or require Firebase Auth contexts like `onCall` functions do.
**Prevention:** When exposing functions via `onRequest` for direct browser/HTTP access, manually parse the `Authorization: Bearer <token>` header, verify the token using `getAuth().verifyIdToken()`, and combine this with proper CORS handling.
