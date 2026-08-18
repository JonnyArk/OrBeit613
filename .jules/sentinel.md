## 2024-05-24 - Missing Authentication on Cloud Functions
**Vulnerability:** The AI API endpoints (`generateAsset`, `distillContext`, `creditUsage`) were deployed as public `onRequest` HTTP functions with absolutely no authentication or authorization checks, allowing anyone to consume the 25,000 monthly Google AI Ultra credits.
**Learning:** The frontend used `httpsCallable` which automatically passes the `Authorization: Bearer <token>` header, but the backend was configured as an Express-style `onRequest` endpoint rather than an `onCall` function, so it completely ignored the token and processed requests anonymously.
**Prevention:** Always use `onCall` for Firebase Functions that require client authentication, or explicitly implement a `verifyIdToken` middleware check for `onRequest` endpoints.
## 2024-05-24 - IDOR Vulnerability in Cloud Functions
**Vulnerability:** The AI API endpoints (`generateAsset`, `distillContext`) previously allowed an Insecure Direct Object Reference (IDOR) by prioritizing the `body.userId` provided by the client over the verified `userId` obtained from the authentication token.
**Learning:** Any authenticated user could bypass authorization by passing another user's ID in the request body, allowing them to use other users' credits or perform unauthorized actions on their behalf.
**Prevention:** Strictly enforce the authenticated identity by directly overwriting the `body.userId` with the server-side verified `userId` from the authentication token, completely ignoring any `userId` the client attempts to inject in the request payload.
