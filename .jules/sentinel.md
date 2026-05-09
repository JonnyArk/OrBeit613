## 2024-05-09 - Missing Authentication on Firebase v2 onRequest
**Vulnerability:** Firebase v2 `onRequest` functions do not automatically enforce authentication, exposing sensitive endpoints to public access without verification.
**Learning:** Unlike Callable functions, HTTP triggers (`onRequest`) are public by default and require manual validation of Firebase ID tokens via `getAuth().verifyIdToken()` to protect resources.
**Prevention:** Always implement explicit authentication checks (e.g., using a `requireAuth` helper) on sensitive HTTP endpoints and return generic 401 Unauthorized responses to avoid leaking internals.
