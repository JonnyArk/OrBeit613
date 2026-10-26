## 2024-10-26 - Missing Authentication on Cloud Functions v2 onRequest Endpoints
**Vulnerability:** The creditUsage, generateAsset, and distillContext Cloud Functions v2 onRequest endpoints were exposed publicly without authentication, allowing anyone to consume AI credits or view usage data.
**Learning:** Firebase Cloud Functions v2 onRequest HTTP endpoints do not have built-in authentication context (unlike onCall functions), requiring manual extraction of the Bearer token and verification via getAuth().verifyIdToken().
**Prevention:** Always manually verify the Bearer token in a try...catch block (returning a generic 401 on failure to avoid leaking errors) for all sensitive onRequest endpoints, while keeping the healthCheck endpoint explicitly public for automated monitoring.
