## 2024-05-24 - Missing Authentication on Cloud Functions
**Vulnerability:** Found `generateAsset` and `distillContext` functions using `onRequest` (HTTP triggers) without checking for authentication. This allows unauthenticated external access to sensitive AI capabilities and uses up the AI credit limit.
**Learning:** `onRequest` does not automatically authenticate users like `onCall` does. Authentication needs to be manually verified via Authorization headers.
**Prevention:** Always manually verify the Bearer token using Firebase Admin `verifyIdToken` in `onRequest` triggers or use `onCall` triggers if possible. Ensure CORS middleware wraps the auth validation.
