## 2025-02-27 - Secured AI Endpoints against IDOR
**Vulnerability:** IDOR/Spoofing vulnerability in `onRequest` AI endpoints (`generateAsset`, `distillContext`). The `userId` was accepted directly from the client request body, allowing a malicious user to bill AI credit usage to any other user's account by spoofing their ID.
**Learning:** In Firebase Functions, HTTP `onRequest` endpoints do not automatically inject `request.auth.uid` like `onCall` endpoints do.
**Prevention:** For any sensitive operation exposed via `onRequest`, explicitly verify the `authorization` header using `getAuth().verifyIdToken(token)` and use the extracted `uid` to overwrite any client-provided user IDs.
