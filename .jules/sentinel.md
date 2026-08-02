## 2024-08-02 - [Sentinel] Fix missing auth on expensive endpoints
**Vulnerability:** Found missing authentication checks on AI Cloud Function endpoints (generateAsset, distillContext) that consume credits.
**Learning:** Unauthenticated sensitive endpoints allow resource exhaustion and unauthorized access, particularly in Firebase where `onRequest` does not automatically check auth unlike `onCall`.
**Prevention:** Always extract and verify `request.headers.authorization` using `getAuth().verifyIdToken` in `onRequest` endpoints or use `onCall` for client integration.
