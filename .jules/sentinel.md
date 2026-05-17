## 2024-05-17 - Prevent Error Message Information Leakage
**Vulnerability:** Raw error messages (e.g., `error.message`) were being returned directly in HTTP responses from Firebase Cloud Functions.
**Learning:** Returning raw error details to the client can expose sensitive backend internals, stack traces, or third-party service details to potential attackers.
**Prevention:** Always log detailed errors internally using the logger, but return generic, safe error messages (like 'An internal error occurred') to the client in HTTP responses.
