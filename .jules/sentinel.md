## 2026-02-05 - [CRITICAL] Unsecured Public AI Endpoints
**Vulnerability:** Expensive AI generation functions (`generateAsset`, `distillContext`) were exposed as public HTTP endpoints (`onRequest`) with NO authentication, allowing anyone to drain project credits.
**Learning:** The Flutter client was using `httpsCallable` (implying `onCall`), but the server was implemented as `onRequest`. This mismatch created a silent vulnerability where the client *thought* it was secure but the server was wide open.
**Prevention:** Always verify function triggers match client expectations. Enforce `if (!request.auth)` on ALL callable functions unless explicitly public. Use `onCall` for client-to-server communication.
