## YYYY-MM-DD - Missing authentication on AI endpoints
**Vulnerability:** AI endpoints were accessible without authentication because they used `onRequest` instead of `onCall`.
**Learning:** Flutter clients invoking functions with `httpsCallable` expect `onCall` backend functions, which natively enforce authentication and unwrap the `data` payload.
**Prevention:** Use `onCall` instead of `onRequest` for endpoints serving client apps to ensure Firebase Auth tokens are verified automatically via `request.auth`.
