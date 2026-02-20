## 2026-02-05 - Unauthenticated AI Functions
**Vulnerability:** Public `onRequest` endpoints (`generateAsset`, `distillContext`) were exposed without authentication checks, allowing unrestricted access to paid AI resources.
**Learning:** `onRequest` functions do not enforce authentication by default and receive raw HTTP requests, unlike `onCall` which automatically handles auth tokens.
**Prevention:** Use `onCall` for client-callable functions or explicitly check `request.auth` in `onRequest` handlers. Always validate authentication before processing sensitive operations.
