## 2024-05-18 - Missing Authentication and IDOR on AI Endpoints
**Vulnerability:** `generateAsset` and `distillContext` Cloud Functions used HTTP `onRequest` without Bearer token validation and trusted the client-provided `userId` in the payload (IDOR).
**Learning:** Even internal AI orchestration endpoints require strict auth and IDOR protection. Do not assume `onRequest` handles auth natively like `onCall` does.
**Prevention:** Always extract `decodedToken.uid` from `getAuth().verifyIdToken(token)` and strictly overwrite `body.userId` in the request payload. Never fallback to client `userId`.
