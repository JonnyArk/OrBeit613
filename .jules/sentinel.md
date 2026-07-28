## YYYY-MM-DD - Missing Authentication on Firebase Functions
**Vulnerability:** Critical AI endpoints (`generateAsset`, `distillContext`) were exposed globally via `onRequest` without authentication, allowing unauthorized use of paid Google AI APIs.
**Learning:** Flutter's `httpsCallable` expects `onCall` endpoints. Using `onRequest` not only breaks the native payload unwrapping but entirely bypasses Firebase Authentication verification (`request.auth`).
**Prevention:** Always use `onCall` for Firebase Cloud Functions that are invoked by client SDKs (`httpsCallable`), and explicitly check `request.auth` to ensure the caller is authenticated.
