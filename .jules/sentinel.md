## 2023-10-03 - Missing Authentication on Sensitive v2 Cloud Functions
**Vulnerability:** The `generateAsset` and `distillContext` `onRequest` endpoints lacked authentication checks and trusted client-provided `userId`s, leading to unauthenticated access and potential IDOR vulnerabilities.
**Learning:** Firebase Cloud Functions v2 `onRequest` endpoints do not have built-in authentication context like `onCall` endpoints. Authentication must be handled manually.
**Prevention:** Always manually extract and verify the `authorization` header using `getAuth().verifyIdToken()` in `onRequest` functions, and always strictly overwrite user-provided IDs with the verified token UID.
