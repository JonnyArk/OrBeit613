## 2026-10-07 - Missing Authentication and IDOR Vulnerability in Cloud Functions
**Vulnerability:** The v2 `onRequest` HTTP endpoints `generateAsset` and `distillContext` were completely unauthenticated and allowed client-provided `userId` payload injection.
**Learning:** Firebase Cloud Functions v2 `onRequest` endpoints do not automatically inject or verify authentication context unlike `onCall` endpoints, requiring manual `getAuth().verifyIdToken()` usage.
**Prevention:** Always manually extract and verify the Authorization Bearer token in `onRequest` functions, and strictly overwrite request payload user identifiers with the decoded server-side identity (`decodedToken.uid`) to prevent IDOR.
