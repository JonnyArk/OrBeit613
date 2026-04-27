## 2025-04-27 - Missing Authentication on Firebase v2 onRequest Functions
**Vulnerability:** Firebase v2 `onRequest` HTTP functions (`generateAsset`, `distillContext`) lacked authentication, allowing unauthorized access to AI credit consumption endpoints and risking IDOR by trusting client-provided user IDs.
**Learning:** Unlike Callable functions (`onCall`), Firebase v2 `onRequest` functions are public by default and do not automatically enforce authentication.
**Prevention:** Always manually implement explicit authentication checks (e.g., using `getAuth().verifyIdToken()`) on sensitive `onRequest` endpoints and securely inject the derived `uid` into the payload instead of trusting client input.
