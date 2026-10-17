## 2024-10-17 - Missing Auth in Firebase v2 onRequest Endpoints
**Vulnerability:** The Firebase v2 `onRequest` endpoints (`creditUsage`, `generateAsset`, `distillContext`) lack built-in authentication, exposing sensitive operations and billing vectors to unauthenticated users.
**Learning:** Unlike `onCall` functions, `onRequest` endpoints in Firebase v2 do not automatically parse or enforce authentication contexts. They act as raw HTTP endpoints.
**Prevention:** Always manually extract the Bearer token from `request.headers.authorization` and verify it using `getAuth().verifyIdToken()` from `firebase-admin/auth` for all sensitive `onRequest` functions.
