## 2023-10-30 - Unauthenticated Cloud Functions
**Vulnerability:** The `creditUsage`, `generateAsset`, and `distillContext` Firebase Cloud Functions were publicly accessible without any authentication checks.
**Learning:** `onRequest` functions in Firebase v2 do not automatically enforce authentication, unlike `onCall` functions. We must manually parse and verify the Bearer token using `getAuth().verifyIdToken()`.
**Prevention:** Always implement explicit token verification using `getAuth().verifyIdToken()` in a `try/catch` block for any sensitive `onRequest` endpoint. Never assume endpoints are protected by default.
