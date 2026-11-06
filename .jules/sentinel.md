## 2026-02-05 - Missing Authentication on HTTP Endpoints
**Vulnerability:** HTTP Cloud Functions (creditUsage, generateAsset, distillContext) lacked Bearer token verification.
**Learning:** onRequest functions in Firebase do not automatically enforce authentication. They must explicitly verify the Authorization header.
**Prevention:** Always use a helper to verify getAuth().verifyIdToken() or switch to onCall functions for authenticated endpoints.
