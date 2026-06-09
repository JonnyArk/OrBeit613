## 2024-06-09 - Missing Authentication on Cloud Functions
**Vulnerability:** Unauthenticated access to sensitive AI endpoints (`generateAsset`, `distillContext`).
**Learning:** `onRequest` Firebase Cloud Functions accessed by browser clients must be secured with a CORS wrapper combined with manual authentication (`requireAuth`) so that `OPTIONS` preflight requests pass smoothly without returning 401 Unauthorized.
**Prevention:** Always combine `cors` wrapper with `requireAuth` in `onRequest` endpoints.
