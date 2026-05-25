## 2024-05-25 - Unauthorized Access to AI Endpoints
**Vulnerability:** Missing authentication on `onRequest` Cloud Functions endpoints that consume expensive AI resources (`generateAsset`, `distillContext`).
**Learning:** `onRequest` functions in Firebase v2 do not automatically check authentication. They are public by default unless protected.
**Prevention:** Always verify `Authorization` tokens using `requireAuth` helper on any `onRequest` endpoint before processing requests, especially those consuming billed resources.
