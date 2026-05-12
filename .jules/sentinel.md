## 2026-05-12 - Missing Authentication on Firebase v2 HTTP Endpoints
**Vulnerability:** The `creditUsage`, `generateAsset`, and `distillContext` Firebase v2 `onRequest` functions were publicly accessible without any authentication checks.
**Learning:** Unlike Callable functions, Firebase v2 `onRequest` HTTP endpoints are public by default and do not automatically verify user identities or enforce authentication. This can expose sensitive logic or data, or permit unauthenticated usage of underlying paid APIs.
**Prevention:** Always manually implement explicit authentication checks (e.g., extracting the `Bearer` token and using `getAuth().verifyIdToken()`) at the start of any `onRequest` function that protects sensitive data or actions.
