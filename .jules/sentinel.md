## 2024-05-18 - Missing Authentication on Sensitive Endpoints
**Vulnerability:** Found that AI operations (`distillContext` and `generateAsset`) in Cloud Functions did not require authentication, but consume billable AI usage credits (`googleAIUltraKey`). This exposes the endpoints to potential abuse by anyone who can hit them.
**Learning:** Billable Cloud Functions must use authentication checks to prevent unauthenticated access.
**Prevention:** Use a `requireAuth` helper function or Firebase Auth token verification in all `onRequest` endpoints.
