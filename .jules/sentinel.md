## 2025-02-12 - Missing Authentication in Firebase v2 onRequest Functions
**Vulnerability:** Firebase v2 `onRequest` endpoints (`generateAsset` and `distillContext`) were publicly accessible without requiring authentication, exposing sensitive functionality and potentially incurring AI service costs from unauthorized access.
**Learning:** Unlike Firebase Callable functions (`onCall`), v2 `onRequest` functions do not automatically verify user authentication or enforce context.
**Prevention:** Always manually verify authentication for `onRequest` endpoints by parsing the `Authorization` header and verifying the Firebase ID token using `getAuth().verifyIdToken()`. Ensure unauthorized requests return a 401 response and avoid logging sensitive user data during authentication failures.
