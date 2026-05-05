## 2024-05-05 - Missing Authentication on Public Endpoints
**Vulnerability:** The `generateAsset` and `distillContext` endpoints were exposed publicly without authentication checks.
**Learning:** Firebase v2 `onRequest` functions are public by default, unlike Callable functions. Without explicit auth, attackers could invoke these endpoints and drain the system's AI credits (Credit Exhaustion/DoS) or spoof credit tracking.
**Prevention:** Always implement explicit authentication validation (e.g., `requireAuth`) on `onRequest` endpoints that perform sensitive or metered operations, and securely inject the verified `uid` into the backend payload.
