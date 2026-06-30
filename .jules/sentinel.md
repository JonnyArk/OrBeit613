## YYYY-MM-DD - Missing Authentication in onRequest Cloud Functions
**Vulnerability:** Firebase `onRequest` cloud functions were exposed without authentication.
**Learning:** When securing `onRequest` Firebase Cloud Functions accessed by browser clients, manual authentication with `requireAuth` must be combined with a CORS wrapper. Wrap the endpoint logic with `corsHandler` and run the `requireAuth` check inside the CORS callback so `OPTIONS` preflight requests pass smoothly without returning 401 Unauthorized.
**Prevention:** Always combine `cors` middleware with manual authentication for browser-accessed `onRequest` endpoints.
