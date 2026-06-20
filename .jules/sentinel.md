## 2025-06-20 - Unauthenticated and Non-CORS Cloud Functions
**Vulnerability:** HTTP endpoints `generateAsset`, `distillContext`, and `creditUsage` were publicly accessible without authentication, lacked CORS protection, and leaked sensitive error messages to the client.
**Learning:** Wrapping Firebase `onRequest` functions inside `corsHandler` requires carefully structuring `async/await` inside the middleware callback to prevent unhandled promise rejections, while ensuring authentication occurs post-CORS so preflight `OPTIONS` requests succeed.
**Prevention:** Always apply the `cors` middleware wrapper containing a `requireAuth` check and generic error handling to all sensitive endpoints that are expected to be consumed by client applications.
