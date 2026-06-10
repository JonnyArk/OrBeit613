## 2024-06-10 - Secure Firebase onRequest with CORS and Auth
**Vulnerability:** Publicly accessible `onRequest` Cloud Functions performing costly AI operations without authentication.
**Learning:** When securing `onRequest` Firebase Cloud Functions accessed by browser clients, manual authentication with `requireAuth` must be combined with a CORS wrapper. The `requireAuth` check must run inside the CORS callback (`corsHandler`) so `OPTIONS` preflight requests pass smoothly without returning 401 Unauthorized.
**Prevention:** Always wrap authenticated `onRequest` endpoints with a CORS handler to properly handle preflight requests.
