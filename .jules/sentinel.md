## 2026-05-24 - Missing Authentication on Sensitive Endpoints
**Vulnerability:** Firebase `onRequest` HTTP cloud functions (like `creditUsage`, `generateAsset`, `distillContext`) lacked authentication checks, allowing unauthenticated public access.
**Learning:** Unlike `onCall` functions or Firestore database rules, `onRequest` functions do not automatically verify user authentication or tokens. They are fully public unless explicitly protected.
**Prevention:** Always use the `requireAuth` helper function at the start of any `onRequest` handler to verify Firebase ID tokens before processing sensitive data or performing expensive operations.
