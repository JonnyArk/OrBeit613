# Sentinel Journal - Critical Security Learnings

## 2025-02-05 - Insecure AI Cloud Functions
**Vulnerability:** The AI-consuming Cloud Functions (`generateAsset`, `distillContext`) were exposed as public `onRequest` HTTP endpoints without any authentication checks. This allowed unauthenticated users to consume the project's AI quota and budget.
**Learning:** The client code used `httpsCallable`, implying `onCall` functions were expected, but the backend implementation used `onRequest`. This mismatch created a false sense of security where the client sent auth tokens but the server ignored them. `onRequest` functions do not automatically validate Firebase Auth tokens.
**Prevention:** Always use `onCall` (Callable Functions) for endpoints called by the client app, as they automatically handle authentication context (`request.auth`). If `onRequest` is necessary, manually verify the ID token using `admin.auth().verifyIdToken()`.
