## 2025-02-05 - Missing Authentication on Cloud Functions
**Vulnerability:** The `generateAsset` and `distillContext` REST API endpoints in Firebase Cloud Functions v2 (`functions/src/index.ts`) lacked authentication, exposing AI resource consumption to any caller.
**Learning:** Firebase `onRequest` HTTP endpoints are publicly accessible by default. When handling sensitive or cost-incurring operations, token validation must be manually implemented by extracting the token from `request.headers.authorization` and verifying it via `getAuth().verifyIdToken()`.
**Prevention:** Always secure `onRequest` HTTP endpoints with `getAuth().verifyIdToken()` and explicitly handle missing/invalid tokens to return 401 Unauthorized errors securely without exposing validation details.
