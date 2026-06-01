## 2024-05-24 - Missing Authentication on Sensitive Endpoints
**Vulnerability:** Found endpoints `generateAsset` and `distillContext` utilizing Google AI Ultra credits and potentially accessing sensitive data without any authentication checks.
**Learning:** `onRequest` functions in Firebase Cloud Functions don't have built-in authentication validation compared to `onCall` functions.
**Prevention:** Implement the custom `requireAuth` helper from `auth.ts` on all `onRequest` endpoints handling sensitive tasks or consuming resources.
