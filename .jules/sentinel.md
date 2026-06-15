## 2025-06-15 - Fixing missing authentication in Cloud Functions
**Vulnerability:** The generateAsset and distillContext endpoints were publicly exposed without authentication checks, allowing unauthorized users to consume AI credits.
**Learning:** onRequest endpoints accessed by browsers need a CORS wrapper around the requireAuth logic to handle OPTIONS requests properly before evaluating the auth token.
**Prevention:** Always wrap onRequest endpoints intended for browser access with a corsHandler and perform the requireAuth check inside the CORS callback.
