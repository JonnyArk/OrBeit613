## 2024-06-17 - Missing Authentication on Cloud Functions
**Vulnerability:** Firebase Cloud Functions handling AI features (generateAsset, distillContext) were completely public, exposing the application to abuse and credit depletion.
**Learning:** Functions that consume external API credits or handle sensitive data must verify Firebase ID tokens.
**Prevention:** Always wrap Firebase HTTP `onRequest` endpoints with a `requireAuth` helper and proper `cors` configuration before handling any business logic.
