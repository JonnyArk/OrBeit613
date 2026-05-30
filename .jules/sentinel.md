## 2026-05-30 - Add Authentication to onRequest Endpoints
**Vulnerability:** Firebase Cloud Functions 'onRequest' HTTP endpoints lack automatic authentication, allowing unauthenticated access to sensitive operations (credit usage, asset generation, context distillation).
**Learning:** Unlike 'onCall' functions, 'onRequest' functions do not automatically verify Firebase Auth tokens, requiring manual implementation of token verification logic.
**Prevention:** Always implement manual token verification (e.g., using a 'requireAuth' middleware) for 'onRequest' endpoints that expose sensitive data or perform actions on behalf of a user. Handle 'OPTIONS' requests properly to support CORS.
