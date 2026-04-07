## 2025-04-07 - Unauthenticated AI Service Endpoints & IDOR Vulnerability
**Vulnerability:** The AI service HTTP endpoints (`generateAsset` and `distillContext`) lacked authentication checks and trusted the client-provided `userId` in the payload, allowing unauthenticated usage and IDOR/spoofing attacks to consume other users' credits.
**Learning:** Cloud Functions HTTP endpoints (`onRequest`) do not automatically verify Firebase Authentication like `onCall` endpoints do. The `authorization` header must be manually parsed and verified.
**Prevention:** Always extract the Bearer token from `request.headers.authorization` in `onRequest` endpoints, verify it using `getAuth().verifyIdToken(token)`, and securely overwrite the client's `body.userId` with the derived `uid`.
