## YYYY-MM-DD - Missing Authentication on AI Endpoints
**Vulnerability:** Public `onRequest` endpoints (`generateAsset`, `distillContext`) lacked authentication, exposing AI credit consumption to unauthenticated users.
**Learning:** Unlike `onCall` functions which handle auth automatically, `onRequest` REST endpoints in Firebase require explicit token validation to secure them against unauthorized access.
**Prevention:** Always extract `request.headers.authorization` and verify the token using `getAuth().verifyIdToken(token)` for sensitive `onRequest` endpoints.
