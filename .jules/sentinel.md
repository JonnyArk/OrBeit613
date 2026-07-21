## 2025-02-14 - Fix Missing Authentication on AI Endpoints
**Vulnerability:** The AI Cloud Functions (`generateAsset`, `distillContext`, `creditUsage`) were accessible to anyone without an authentication check, meaning an unauthenticated attacker could continuously call the functions and exhaust the monthly limits (Financial exhaustion).
**Learning:** These endpoints were created with `onRequest` which defaults to public, relying only on parameter structures or external access layers that don't block direct API requests.
**Prevention:** For any `onRequest` functions that should be private, always enforce user validation by passing the request through a middleware that decodes and validates a Firebase Auth Bearer token inside the `cors` callback.
