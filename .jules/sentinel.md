## 2026-02-05 - Unprotected AI Endpoints
**Vulnerability:** The `generateAsset` and `distillContext` Cloud Functions were exposed as public HTTP endpoints (`onRequest`) without authentication, allowing anyone to trigger expensive AI operations.
**Learning:** Developers may use `onRequest` for simplicity during development or testing, forgetting that it bypasses Firebase Auth context unless manually verified. The client code using `httpsCallable` was likely broken or relying on undefined behavior.
**Prevention:** Strictly enforce `onCall` for all client-facing functions. Add automated linting or review rules to flag `onRequest` usage that lacks explicit auth checks.
