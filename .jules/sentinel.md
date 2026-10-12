## 2024-10-12 - Missing Auth on Firebase HTTP Functions
**Vulnerability:** HTTP functions (generateAsset, distillContext, creditUsage) missed auth checks, exposing AI endpoints.
**Learning:** In Firebase Cloud Functions v2, onRequest HTTP endpoints do not have built-in authentication context (unlike onCall functions).
**Prevention:** Always manually extract the Bearer token from request.headers.authorization and verify it using getAuth().verifyIdToken() for onRequest functions.
