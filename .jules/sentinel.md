## 2024-08-13 - Missing Authentication on REST Endpoints
**Vulnerability:** Sensitive Firebase `onRequest` endpoints (`creditUsage`, `generateAsset`, `distillContext`) were exposed publicly without token verification.
**Learning:** `onRequest` does not automatically validate authentication like `onCall` does, leaving API keys and backend resources vulnerable if not explicitly secured via headers.
**Prevention:** Always implement explicit token validation extracting `request.headers.authorization` and verifying it via `getAuth().verifyIdToken()` for HTTP REST endpoints handling sensitive or billed operations.
