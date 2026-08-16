## 2026-08-16 - Unauthenticated AI Service Endpoints
**Vulnerability:** The `generateAsset` and `distillContext` Firebase Cloud Functions were exposed as unauthenticated REST endpoints (via `onRequest`), allowing anyone to trigger AI processing and drain credits.
**Learning:** Using `onRequest` for REST APIs requires manual authentication implementation, unlike `onCall` which handles auth automatically.
**Prevention:** Always validate `request.headers.authorization` with `getAuth().verifyIdToken()` on sensitive `onRequest` endpoints, or switch to `onCall` if strict REST compatibility isn't required.
