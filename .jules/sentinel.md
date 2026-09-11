## 2023-10-25 - IDOR and Missing Auth in Cloud Functions
**Vulnerability:** The public `onRequest` Cloud Functions (`distillContext`, `generateAsset`) lacked authentication checks and trusted the `userId` directly from the client's HTTP request body, enabling Insecure Direct Object Reference (IDOR) attacks.
**Learning:** In Firebase Cloud Functions v2 `onRequest` endpoints, there is no built-in auth verification like in `onCall`. The payload must never be trusted as the source of identity.
**Prevention:** Always implement explicit JWT token verification using `firebase-admin/auth` for `onRequest` endpoints and strictly overwrite any user IDs in the request body with the verified identity extracted from the token.
