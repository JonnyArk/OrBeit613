## 2024-05-18 - Fix IDOR and Auth Bypass in AI endpoints
**Vulnerability:** AI HTTP (`onRequest`) endpoints lacked authentication and trusted the client-provided `userId` in the payload body, exposing them to IDOR and spoofing vulnerabilities.
**Learning:** `onRequest` functions do not automatically verify user authentication unlike `onCall` endpoints. Thus, the identity must be verified manually via the Authorization header.
**Prevention:** Explicitly verify the `Authorization` bearer token using `getAuth().verifyIdToken()` and overwrite the client's `userId` with the securely derived `uid` before processing business logic.
