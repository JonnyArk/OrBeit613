## 2024-05-21 - Unauthenticated AI Resource Endpoints
**Vulnerability:** The `onRequest` Cloud Functions exposing the Whisk and Flow AI services, which consume the limited 25,000 monthly Google AI Ultra credits, were publicly accessible without authentication.
**Learning:** Unlike `onCall` functions which automatically handle and verify Firebase Auth tokens, `onRequest` HTTP endpoints require manual token parsing and verification.
**Prevention:** Always implement a `requireAuth` middleware or helper function for all sensitive `onRequest` Firebase Cloud Functions to prevent unauthorized resource consumption and potential DoS via credit exhaustion.
