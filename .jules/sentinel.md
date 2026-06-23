## 2024-06-23 - Unauthenticated AI Resource Consumption
**Vulnerability:** Missing authentication on the `generateAsset` endpoint in `functions/src/index.ts`.
**Learning:** Express middleware (like `cors`) in Firebase `onRequest` functions requires the inner async callback to be wrapped in a `try/catch` block. Unhandled promise rejections (like from `requireAuth`) can crash the instance or leak state.
**Prevention:** Always combine `requireAuth` with a `cors` wrapper and handle errors securely within the callback for `onRequest` functions accessed by browser clients.
