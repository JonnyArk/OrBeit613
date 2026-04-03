## 2024-03-20 - Prevent IDOR in AI Endpoints
**Vulnerability:** AI endpoints exposed via `onRequest` (`creditUsage`, `generateAsset`, `distillContext`) accepted a client-provided `userId` in the request body without authenticating the caller, allowing malicious users to spoof IDs and consume credits for arbitrary users.
**Learning:** Using `onRequest` bypasses the automatic context provided by `onCall`. As a result, endpoints handling sensitive operations (like AI credit usage) require manual JWT verification to establish trust.
**Prevention:** Always verify authorization headers using `getAuth().verifyIdToken()` in `onRequest` functions and overwrite client-provided IDs with the authenticated token's `uid`.
