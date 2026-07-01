## 2024-05-24 - [Authentication on onRequest Endpoints]
**Vulnerability:** Missing authentication on sensitive onRequest endpoints.
**Learning:** Manual authentication checks (requireAuth) combined with a CORS wrapper allow secure validation while gracefully handling OPTIONS preflight requests in Express-based Firebase Cloud Functions.
**Prevention:** Wrap all browser-accessed endpoints with cors middleware, placing auth validation logic inside the callback rather than directly at the root, to ensure proper processing of preflight checks.
