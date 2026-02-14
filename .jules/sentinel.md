# Sentinel's Journal

## 2026-02-05 - Unauthenticated AI Generation Endpoints
**Vulnerability:** The `generateAsset` and `distillContext` Cloud Functions were exposed as public HTTP endpoints (`onRequest`) without any authentication checks, allowing anyone to trigger expensive AI operations.
**Learning:** Using `onRequest` for client-facing features requires manual authentication verification (e.g., verifying ID tokens). The codebase incorrectly assumed `onRequest` would be secure or was intended for public access, but the functionality (AI generation) is sensitive and costly.
**Prevention:** Always use `onCall` (Callable Functions) for functions called directly by the client app, as it automatically handles Firebase Auth token verification. For `onRequest` endpoints, explicit token verification middleware must be implemented.
