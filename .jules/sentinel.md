## 2024-06-25 - Secure HTTPS Functions with CORS and Auth
**Vulnerability:** Public, unauthenticated endpoints (`generateAsset`, `distillContext`) performing sensitive operations and consuming AI credits, exposed to SSRF/abuse.
**Learning:** Wrapping `onRequest` with `cors` requires putting the authentication checks inside the CORS callback to ensure preflight requests pass smoothly without returning 401 Unauthorized.
**Prevention:** Always combine manual authentication (`requireAuth`) with a CORS wrapper and ensure the async callback is properly wrapped in a `try/catch` block to handle unhandled promise rejections.
