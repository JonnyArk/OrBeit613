## 2026-05-27 - Missing Auth & Info Leak in Firebase onRequest Functions
**Vulnerability:** Firebase Cloud Functions using `onRequest` (`creditUsage`, `generateAsset`, `distillContext`) lacked authentication checks and leaked internal error messages to clients.
**Learning:** `onRequest` functions are public by default and do not automatically verify Firebase ID tokens. Furthermore, returning `error.message` directly in HTTP responses exposes internal system details.
**Prevention:** Always use the custom `requireAuth` helper to manually verify structural `TypedRequest` and `TypedResponse` objects for `onRequest` endpoints. Always catch errors and return generic messages like "An internal error occurred" to clients while logging detailed errors internally.
