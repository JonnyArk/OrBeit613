## 2026-06-26 - Securing onRequest Firebase Functions

**Vulnerability:** Unauthenticated access to sensitive Firebase Cloud Functions (`generateAsset`, `distillContext`, `creditUsage`), allowing anyone to consume AI credits and resources.
**Learning:** Firebase `onRequest` functions do not inherently enforce authentication. When securing them with a manual `requireAuth` check, they must also be wrapped in a CORS handler so that OPTIONS preflight requests succeed.
**Prevention:** Always wrap sensitive `onRequest` functions with a CORS handler and place the authentication check inside the CORS callback. Ensure the inner callback is wrapped in a try/catch to prevent unhandled promise rejections.
