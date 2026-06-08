## 2024-06-08 - Added Authentication to Cloud Functions
**Vulnerability:** Sensitive API endpoints (`generateAsset`, `distillContext`, `creditUsage`) were entirely missing authentication, allowing any unauthenticated user to consume resources (AI generation limits/credits).
**Learning:** In Firebase v2 `onRequest` endpoints accessed by browsers, manual authentication with `requireAuth` must be combined with a CORS wrapper. Otherwise CORS preflight `OPTIONS` requests fail with 401 Unauthorized before the actual request hits the endpoint.
**Prevention:** Always wrap `onRequest` functions that require auth with `corsHandler`, and run the `requireAuth` check inside the CORS callback to let `OPTIONS` pass smoothly.
