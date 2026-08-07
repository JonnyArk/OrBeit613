## YYYY-MM-DD - Missing Authentication on AI Endpoints
**Vulnerability:** The AI asset generation (`generateAsset`) and context distillation (`distillContext`) Cloud Functions lacked authentication checks.
**Learning:** These `onRequest` endpoints are accessible without authorization, which could lead to unauthorized AI API usage and credit consumption. Explicitly validating tokens on `onRequest` functions is required for securing them.
**Prevention:** When exposing sensitive operations via `onRequest` instead of `onCall`, always implement explicit token validation extracting the token from `request.headers.authorization` and using `getAuth().verifyIdToken()`.
