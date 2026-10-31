## 2025-02-05 - Missing Authentication on Cloud Functions
**Vulnerability:** The `creditUsage`, `generateAsset`, and `distillContext` Firebase `onRequest` HTTP functions lacked authentication checks, allowing any external user to trigger AI operations and potentially cause resource exhaustion or access sensitive data.
**Learning:** Firebase `onRequest` functions are public by default and do not automatically enforce the authentication rules defined in Firestore. Developers sometimes assume the same protections apply, leaving backend endpoints exposed.
**Prevention:** Always manually verify Bearer tokens using `getAuth().verifyIdToken()` in `onRequest` functions, except for intentional public endpoints like `healthCheck`.
