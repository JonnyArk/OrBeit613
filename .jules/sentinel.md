## 2026-02-05 - Missing Authentication on Sensitive Cloud Functions
**Vulnerability:** Public HTTP endpoints (`onRequest`) were used for sensitive, resource-consuming operations (`creditUsage`, `generateAsset`, `distillContext`) without any authentication checks. This allowed any unauthenticated user to consume AI credits and access system metrics.
**Learning:** Using `onRequest` creates publicly accessible HTTP endpoints by default. Even if the frontend code attempts to use them as Callable functions (`onCall`), the backend remains insecure if `onRequest` is used without manual token verification. The mismatch between frontend intent (`httpsCallable`) and backend implementation (`onRequest`) is a dangerous pattern.
**Prevention:**
1. Always use `onCall` (Callable Functions) for client-facing operations that require authentication, as they provide automatic auth context.
2. If `onRequest` is necessary, manually verify the ID token using `admin.auth().verifyIdToken()` before processing the request.
3. Explicitly check `if (!request.auth)` at the beginning of all sensitive `onCall` functions.
