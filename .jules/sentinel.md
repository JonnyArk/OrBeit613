## 2024-05-28 - Missing Authentication on AI Endpoints
**Vulnerability:** Unauthenticated access to `onRequest` Firebase Cloud Functions (`generateAsset` and `distillContext`) allowing unauthorized AI credit consumption.
**Learning:** Firebase `onRequest` endpoints do not automatically enforce authentication or unwrap Firebase auth tokens like `onCall` endpoints do.
**Prevention:** Always implement explicit token validation using `getAuth().verifyIdToken(token)` on `onRequest` REST endpoints that process sensitive data or consume resources.
