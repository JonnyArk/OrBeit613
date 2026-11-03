## 2024-11-03 - Unauthenticated Cloud Functions
**Vulnerability:** The creditUsage, generateAsset, and distillContext Cloud Function endpoints lacked authentication checks, allowing any external caller to access them.
**Learning:** In Firebase v2 onRequest functions, user authentication is not implicitly verified unlike onCall functions. This must be manually implemented for endpoints consuming resources. The healthCheck endpoint remained public by design.
**Prevention:** Always manually verify IdTokens in onRequest functions processing sensitive data or consuming quotas.
