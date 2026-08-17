## 2025-02-18 - Missing Authentication on onRequest Endpoints
**Vulnerability:** Unauthenticated REST endpoints (`onRequest`) allowing anyone to trigger expensive operations (e.g. `generateAsset`, `distillContext`).
**Learning:** Functions migrated or written as `onRequest` instead of `onCall` do not have built-in Firebase authentication, leading to unauthorized access and potential resource exhaustion.
**Prevention:** Always extract and manually verify the ID token from `request.headers.authorization` using `getAuth().verifyIdToken()` for `onRequest` endpoints.
