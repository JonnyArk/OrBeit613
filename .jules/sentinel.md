# Sentinel's Journal

## 2026-02-05 - Insecure AI Cloud Functions
**Vulnerability:** The critical AI services (`generateAsset`, `distillContext`) and credit tracking (`creditUsage`) were exposed as public `onRequest` endpoints. This meant they lacked authentication and authorization checks, allowing any internet user to trigger expensive AI operations and potentially drain the project's credit quota.
**Learning:** Even when client-side code uses `httpsCallable`, the backend implementation must explicitly use `onCall` (or manually verify tokens in `onRequest`) to enforce security. The assumption that `httpsCallable` automatically secures the backend without corresponding backend code changes is a dangerous fallacy.
**Prevention:** Always implement Callable Functions using `onCall` in v2 (or `functions.https.onCall` in v1). If `onRequest` is strictly necessary, manual JWT verification via `admin.auth().verifyIdToken()` is mandatory.
