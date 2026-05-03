## 2024-05-03 - Missing Authentication on Sensitive v2 onRequest Endpoints
**Vulnerability:** Firebase v2 `onRequest` cloud functions (`creditUsage`, `generateAsset`, `distillContext`) were completely public and unauthenticated by default.
**Learning:** Unlike v1 or Callable functions, v2 `onRequest` functions do not enforce authentication automatically. Any client could invoke these endpoints and consume valuable Google AI Ultra API credits without authorization, leading to financial drain (Denial of Wallet).
**Prevention:** Always implement explicit authentication validation (e.g., `getAuth().verifyIdToken()`) manually inside sensitive `onRequest` handlers to protect restricted operations and enforce secure usage.
