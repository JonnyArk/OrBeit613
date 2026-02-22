## 2026-02-05 - Insecure Function Bindings
**Vulnerability:** Backend functions (`generateAsset`, `distillContext`) were defined as `onRequest` (ignoring auth) while client code used `httpsCallable` (sending auth). This created a false sense of security where anyone could call the HTTP endpoints without authentication.
**Learning:** `httpsCallable` on the client does NOT automatically enforce auth on `onRequest` functions. The backend MUST use `onCall` or manually verify tokens.
**Prevention:** Always match `httpsCallable` with `onCall`. Use linting rules or explicit reviews to ensure backend signatures match client usage patterns.
