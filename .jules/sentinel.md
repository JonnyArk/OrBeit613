## 2026-05-28 - Fix Missing Authentication on Cloud Functions
**Vulnerability:** Missing authentication on sensitive Firebase Cloud Functions endpoints (`creditUsage`, `generateAsset`, `distillContext`).
**Learning:** `onRequest` endpoints do not inherently verify Firebase Auth tokens; they require explicit middleware or manual token verification, unlike `onCall` handlers.
**Prevention:** Always implement an authentication verification step (e.g., `requireAuth` using `getAuth().verifyIdToken()`) at the top of any sensitive `onRequest` endpoint. Ensure OPTIONS requests are allowed through for CORS preflight.
