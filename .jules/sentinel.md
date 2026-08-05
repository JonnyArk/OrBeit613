## YYYY-MM-DD - Missing Authentication in AI Endpoints
**Vulnerability:** The `generateAsset` and `distillContext` AI endpoints were deployed as public `onRequest` Cloud Functions without authentication.
**Learning:** These endpoints lacked implicit authorization which is otherwise provided natively by converting endpoints to `onCall` or implementing token verification explicitly, exposing AI functionality.
**Prevention:** Ensure explicit token validation by extracting the token from `request.headers.authorization` and verifying it using `getAuth().verifyIdToken(token)` before processing the request in `onRequest` AI endpoints.
