## YYYY-MM-DD - [Missing Authentication on AI Cloud Functions]
**Vulnerability:** [The `creditUsage`, `generateAsset`, and `distillContext` `onRequest` endpoints lack authentication checks, allowing unauthenticated access.]
**Learning:** [Firebase `onRequest` functions do not inherently validate user identity, unlike `onCall` functions, and explicitly require manual token verification via `request.headers.authorization`.]
**Prevention:** [Implement a helper function utilizing `firebase-admin/auth` `getAuth().verifyIdToken` to validate the authorization token on all sensitive `onRequest` endpoints, failing securely with a 401 response if validation fails.]
