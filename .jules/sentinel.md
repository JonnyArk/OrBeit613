## 2025-02-12 - Unauthenticated Cloud Functions
**Vulnerability:** Missing authentication on Firebase v2 onRequest endpoints (healthCheck, creditUsage, generateAsset, distillContext) allowed unauthenticated access to sensitive operations and AI credits.
**Learning:** Firebase v2 onRequest endpoints do not automatically inject or enforce auth context unlike onCall endpoints, requiring manual token extraction and verification.
**Prevention:** Always manually extract the Bearer token from headers and verify it using getAuth().verifyIdToken() wrapped in a try...catch block for all sensitive v2 onRequest endpoints.
