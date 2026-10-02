## 2024-05-24 - Missing Auth in Cloud Functions v2 onRequest Endpoints
**Vulnerability:** The AI generation and distillation endpoints (`generateAsset` and `distillContext`) were exposed without authentication, allowing anyone to trigger them and consume AI credits, as well as being vulnerable to IDOR via client-provided user IDs.
**Learning:** In Firebase Cloud Functions v2, `onRequest` endpoints lack built-in auth context. We must manually extract the Bearer token and verify it using `getAuth().verifyIdToken()`. Never trust client-provided user IDs.
**Prevention:** Always implement manual token verification for `onRequest` endpoints. Always overwrite request payload `userId` fields with the verified server-side token UID.
