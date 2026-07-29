## YYYY-MM-DD - Firebase Functions Authentication Bypass
**Vulnerability:** Missing authentication and payload mismatch on AI endpoints due to using `onRequest` instead of `onCall`.
**Learning:** Using `onRequest` for endpoints called by Flutter's `httpsCallable` breaks payload parsing (it expects `data` wrapping) and bypasses native authentication checks, exposing sensitive AI endpoints to public unauthenticated access.
**Prevention:** Always use `onCall` for endpoints intended to be called directly by client SDKs, and explicitly check `request.auth` to enforce authentication.
## YYYY-MM-DD - Missing Authentication on Documented REST Endpoints
**Vulnerability:** Sensitive AI endpoints exposed via `onRequest` lacked authentication checks, allowing public unauthorized access to consume AI credits.
**Learning:** Documented REST APIs exposed via `onRequest` must explicitly validate authentication tokens (e.g., using `getAuth().verifyIdToken()`), as they do not automatically verify user identities like Firebase `onCall` functions do. Converting `onRequest` to `onCall` breaks the existing REST API contract.
**Prevention:** Always implement explicit identity verification and authorization guards on `onRequest` endpoints before returning sensitive data or performing billed operations.
