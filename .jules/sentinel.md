## 2024-05-24 - Missing Authentication on Cloud Functions v2 onRequest Endpoints
**Vulnerability:** Firebase Cloud Functions v2 onRequest endpoints do not automatically authenticate users like onCall endpoints do.
**Learning:** onRequest handlers expose raw HTTP endpoints and lack the built-in authentication context.
**Prevention:** Always manually extract the Bearer token from request.headers.authorization and verify it using getAuth().verifyIdToken() for any sensitive onRequest endpoints.
