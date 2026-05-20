## 2024-05-20 - Missing Authentication on Sensitive Endpoints
**Vulnerability:** The `/generateAsset` and `/distillContext` endpoints in `functions/src/index.ts` use `onRequest` but don't verify any authentication. This exposes the endpoints to unauthorized use, which can lead to excessive costs and data manipulation by bad actors.
**Learning:** `onRequest` functions in Firebase do not automatically require authentication like `onCall` functions do. We must explicitly verify Firebase ID tokens or API keys within the function logic.
**Prevention:** For any sensitive operation exposed via `onRequest`, use a helper (like `requireAuth` in `functions/src/auth.ts`) to verify `req.headers.authorization` before proceeding with the logic.
