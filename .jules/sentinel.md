## 2026-02-05 - IDOR and Unauthenticated Endpoints in Firebase Functions
**Vulnerability:** Firebase `onRequest` endpoints lacked authentication checks and trusted client-provided `userId` in the request body for AI resource tracking and operations.
**Learning:** Cloud Functions using `onRequest` do not automatically verify Firebase Authentication tokens (unlike `onCall`), exposing the endpoints to unauthorized access and IDOR if the client's `userId` is trusted without verification.
**Prevention:** Always verify the Firebase ID token manually for `onRequest` endpoints and use the authenticated `uid` to override any client-provided user IDs.
