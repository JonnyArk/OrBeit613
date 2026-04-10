## 2026-04-10 - Protect AI Endpoints from Unauthorized Access and IDOR
**Vulnerability:** Publicly exposed HTTP endpoints (creditUsage, generateAsset, distillContext) for AI services without authentication. Also, AI endpoints relied on client-provided user IDs which can lead to spoofing (IDOR).
**Learning:** AI endpoints must verify ID tokens and strictly derive the `userId` directly from the authenticated `uid` instead of trusting the client payload.
**Prevention:** Always use the `requireAuth` helper and overwrite `body.userId = uid;` for AI service endpoints.
