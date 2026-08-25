
## 2026-08-25 - [Missing Authentication on v2 HTTP Functions]
**Vulnerability:** Firebase v2 `onRequest` Cloud Functions do not enforce authentication by default, exposing sensitive AI endpoints to unauthorized use.
**Learning:** Unlike Callable functions (`onCall`), v2 HTTP functions (`onRequest`) require explicit extraction and verification of the `Authorization` header via `getAuth().verifyIdToken()`.
**Prevention:** Always implement explicit token verification logic or use `onCall` for protected API endpoints.
