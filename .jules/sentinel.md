## YYYY-MM-DD - Missing Auth on Sensitive Endpoints
**Vulnerability:** Missing authentication checks on AI `onRequest` endpoints.
**Learning:** Using `onRequest` instead of `onCall` requires manual token verification, which was overlooked.
**Prevention:** Explicitly validate tokens using `getAuth().verifyIdToken()` or use `onCall` for client-facing functions.
