## 2024-04-26 - Missing Explicit Authentication on onRequest Endpoints
**Vulnerability:** The public Firebase v2 `onRequest` endpoints (`generateAsset`, `distillContext`) lacked authentication, allowing any unauthenticated user to consume AI credits and interact with sensitive endpoints.
**Learning:** Unlike Callable functions (`onCall`), `onRequest` functions are public by default and do not automatically enforce authentication. Always manually implement explicit authentication checks on sensitive endpoints.
**Prevention:** Use a `requireAuth` helper (e.g., `getAuth().verifyIdToken()`) to explicitly verify ID tokens and securely inject the authenticated user's ID (`uid`) into the payload.
