## 2026-06-03 - Missing Authentication on Firebase HTTPS endpoints
**Vulnerability:** Firebase `onRequest` endpoints (`generateAsset`, `distillContext`) were completely public, exposing sensitive AI functionality and secrets to unauthenticated access.
**Learning:** `onRequest` functions in Firebase v2 do not automatically enforce authentication unlike `onCall`. Any endpoint exposing sensitive data or operations (like AI generation) must manually implement token verification.
**Prevention:** Always implement and enforce manual token validation (e.g., via a `requireAuth` helper checking `getAuth().verifyIdToken()`) for sensitive `onRequest` HTTP functions.
