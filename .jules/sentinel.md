## 2026-05-16 - Unauthenticated AI Resource Endpoints
**Vulnerability:** Cloud Functions for expensive AI operations (`generateAsset`, `distillContext`) lacked authentication, allowing unauthorized access and potential credit depletion.
**Learning:** Firebase `onRequest` HTTP functions do not automatically verify user authentication tokens unlike `onCall` functions, requiring manual extraction and verification of the Bearer token.
**Prevention:** Always use a custom `requireAuth` helper to validate `request.headers.authorization` on all `onRequest` endpoints handling sensitive operations or resource utilization.
