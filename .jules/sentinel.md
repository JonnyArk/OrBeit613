## YYYY-MM-DD - Missing authentication on onRequest endpoints
**Vulnerability:** The Firebase Cloud Functions `creditUsage`, `generateAsset`, and `distillContext` created with `onRequest` did not have authentication checks, allowing anyone to call them.
**Learning:** `onRequest` functions in Firebase are publicly accessible by default unless authentication is manually verified inside the function, unlike `onCall` functions which handle auth automatically. The `healthCheck` endpoint correctly remained unauthenticated.
**Prevention:** Always verify `request.headers.authorization` containing a valid Bearer token via `getAuth().verifyIdToken()` at the start of sensitive `onRequest` handlers.
