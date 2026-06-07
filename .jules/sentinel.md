## 2024-06-07 - Prevent information leakage in Cloud Functions
**Vulnerability:** Raw error messages (`error.message`) were returned directly to the client in the 500 error responses of `generateAsset` and `distillContext` functions.
**Learning:** Passing underlying error details through API responses risks exposing sensitive internal system configurations, stack traces, or data schemas to unauthorized users.
**Prevention:** Always log detailed errors internally but return a generic, non-specific error message (e.g., "An internal error occurred") to clients when failing securely.
