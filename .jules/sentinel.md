## 2024-05-18 - Missing Authentication on Cloud Functions
**Vulnerability:** Found missing authentication checks on multiple sensitive endpoints (`generateAsset` and `distillContext`).
**Learning:** In Firebase Cloud Functions, `onRequest` functions are publicly accessible by default unless an explicit check is implemented. This could lead to unauthorized API access and billing abuse since it calls external AI APIs.
**Prevention:** Always use the `requireAuth` helper function or wrap logic with explicit authentication validation on `onRequest` endpoints.
