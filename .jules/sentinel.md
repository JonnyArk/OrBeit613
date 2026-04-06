## 2024-04-06 - Missing Auth and IDOR on AI Endpoints
**Vulnerability:** AI endpoints (`creditUsage`, `generateAsset`, `distillContext`) in `functions/src/index.ts` lacked authentication. Client-provided `userId` was trusted in the payload, allowing IDOR and credit draining.
**Learning:** Exposing backend AI services via `onRequest` requires manual token verification; unlike `onCall`, it is not automatic. Trusting `body.userId` from the client allows spoofing.
**Prevention:** Always verify headers using `getAuth().verifyIdToken()` in `onRequest` endpoints and overwrite client-supplied IDs with the secure `uid` from the decoded token.
