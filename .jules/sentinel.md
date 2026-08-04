## YYYY-MM-DD - Missing Authentication on Sensitive Endpoints
**Vulnerability:** Missing authentication on `onRequest` REST endpoints (`generateAsset`, `distillContext`).
**Learning:** `onRequest` functions do not natively unwrap payloads or verify Firebase Authentication tokens, leaving cost-incurring endpoints exposed to the public.
**Prevention:** Implement explicit token validation extracting the token from `request.headers.authorization` and verifying it via `getAuth().verifyIdToken()`.
