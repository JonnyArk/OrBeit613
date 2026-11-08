## 2025-02-14 - Missing Authentication on Cloud Functions
**Vulnerability:** The AI endpoints `creditUsage`, `generateAsset`, and `distillContext` lacked authentication, allowing anyone to trigger them and exhaust the AI credit limit.
**Learning:** Firebase `onRequest` functions are public by default and do not automatically enforce authentication rules like `onCall` functions do.
**Prevention:** Always verify the `Authorization` header containing the Bearer token using `getAuth().verifyIdToken()` in `onRequest` functions that perform sensitive operations or consume credits. Wrap this validation in a `try...catch` block to securely return a `401 Unauthorized` response without exposing stack traces. Leave `healthCheck` endpoints unauthenticated for external monitoring.
