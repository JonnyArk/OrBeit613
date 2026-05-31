## 2024-05-31 - Add Authentication to Cloud Functions Endpoints
**Vulnerability:** Missing authentication on sensitive Firebase Cloud Functions endpoints (`onRequest`) exposing credit usage and AI endpoints.
**Learning:** `onRequest` endpoints in Firebase Functions v2 are public by default and do not automatically verify user tokens, unlike callable functions.
**Prevention:** Always implement manual token verification using `firebase-admin/auth` for `onRequest` endpoints or use `onCall` if appropriate. Ensure CORS preflight `OPTIONS` requests are handled.
