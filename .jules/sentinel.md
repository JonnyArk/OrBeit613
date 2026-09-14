## 2026-09-14 - Fix missing authentication on sensitive endpoints
**Vulnerability:** Found `onRequest` endpoints (`generateAsset`, `distillContext`, `creditUsage`) in Firebase Cloud Functions v2 that process sensitive user data and AI generation requests without verifying any authentication. The endpoints were directly accessible.
**Learning:** `onRequest` HTTP endpoints lack the built-in authentication context provided by `onCall`. Firebase v2 `onRequest` handlers require manual extraction and verification of the Bearer token using `getAuth().verifyIdToken()`.
**Prevention:** For `onRequest` endpoints in Firebase v2, always manually verify the `Authorization` header and extract the decoded user ID before processing requests that mutate data or consume credits.
