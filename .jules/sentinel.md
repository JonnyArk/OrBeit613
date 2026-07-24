## YYYY-MM-DD - Convert onRequest to onCall for Authentication
**Vulnerability:** Unauthenticated endpoints for AI services.
**Learning:** Flutter `httpsCallable` natively supports `onCall` which unwraps payloads via `.data` and passes `request.auth` context. `onRequest` required manual payload validation and lacked built-in authentication, leading to exposed AI operations.
**Prevention:** Use `onCall` for Firebase Cloud Functions intended to be invoked by clients, ensuring automatic auth context propagation.
