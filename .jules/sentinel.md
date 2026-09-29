## 2024-05-14 - IDOR Prevention in V2 HTTPS Functions
**Vulnerability:** Missing Authentication/IDOR risk on `onRequest` endpoints.
**Learning:** In Firebase Cloud Functions V2, `onRequest` endpoints do not have built-in authentication context unlike `onCall` endpoints. Thus the `userId` passed from the client body is highly susceptible to IDOR vulnerabilities as anyone could send any `userId` payload.
**Prevention:** For `onRequest` functions, manually extract the token from `request.headers.authorization`, verify it with `getAuth().verifyIdToken()`, and forcefully override any `userId` parameter in the body with the authenticated user's `uid` to strictly enforce authorization.
