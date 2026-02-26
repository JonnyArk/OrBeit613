# Sentinel's Journal

## 2026-02-05 - Unauthenticated AI Service Endpoints
**Vulnerability:** `generateAsset`, `distillContext`, and `creditUsage` were exposed as public `onRequest` HTTP endpoints without any authentication checks. This allowed unauthenticated users to trigger expensive AI operations (consuming `googleAIUltraKey` credits) and view credit usage statistics.
**Learning:** The project used `onRequest` which defaults to public access. While convenient for webhooks, it's dangerous for client-callable business logic. The `AIServiceImpl` on the client was using `httpsCallable`, which implies an expectation of `onCall` semantics, but the server implementation didn't match.
**Prevention:**
1. Prefer `onCall` for all client-facing functions as it automatically provides `request.auth`.
2. If `onRequest` is necessary, implement manual token verification (e.g., `admin.auth().verifyIdToken()`) at the start of the function.
3. Use `onCall` to ensure `userId` is derived from the verified token, not user-supplied body parameters.
