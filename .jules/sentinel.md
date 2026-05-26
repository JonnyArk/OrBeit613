## 2024-05-26 - Missing Authentication on Firebase HTTPS Functions
**Vulnerability:** The sensitive Firebase Cloud Functions `creditUsage`, `generateAsset`, and `distillContext` created using `onRequest` were exposed publicly without any authentication checks.
**Learning:** Unlike `onCall` functions, `onRequest` HTTP functions do not automatically verify Firebase ID tokens, requiring manual implementation to prevent unauthorized access and potential resource abuse.
**Prevention:** Always implement manual authentication verification (e.g., using a `requireAuth` middleware/helper) on all sensitive `onRequest` endpoints.
