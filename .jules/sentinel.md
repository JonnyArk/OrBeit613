## 2026-05-22 - Add authentication and secure error messages to HTTP endpoints
**Vulnerability:** Firebase `onRequest` endpoints lacked manual authentication verification and returned explicit error messages back to the client, leading to unauthenticated access and internal information leakage.
**Learning:** `onRequest` functions do not inherently enforce security rules or check authentication tokens unlike `onCall` functions, meaning explicit verification is always required. Catch blocks can inadvertently expose stack traces or backend logic constraints.
**Prevention:** Always use `requireAuth` manually at the start of every `onRequest` endpoint. Never return raw `error.message` to clients; always return generic error messages instead.
