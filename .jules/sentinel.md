## YYYY-MM-DD - Missing authentication on sensitive endpoints
**Vulnerability:** Firebase Cloud Functions for AI asset generation and context distillation were publicly accessible, allowing potential abuse of AI credits.
**Learning:** When securing `onRequest` Firebase Cloud Functions accessed by browser clients, manual authentication checks (e.g., verifying a Bearer token) must be placed inside the callback of a CORS middleware wrapper to prevent blocking `OPTIONS` preflight requests.
**Prevention:** Always wrap `onRequest` functions with CORS middleware first, then perform token validation within the CORS callback, or use `onCall` functions which handle CORS and auth automatically.
