## 2025-04-13 - Missing Authentication on Cloud Functions
**Vulnerability:** The `generateAsset` and `distillContext` AI service HTTP endpoints lack authentication and rely entirely on client-provided data, potentially exposing AI services and permitting unauthorized access and spoofing.
**Learning:** These endpoints used `onRequest` from `firebase-functions/v2/https` without applying authorization checks on `request.headers.authorization`. This allows any client to send requests containing any `userId` in the body.
**Prevention:** For any `onRequest` HTTP endpoint accessing user data or invoking costly external services, implement token validation (`getAuth().verifyIdToken()`) and overwrite client-supplied `userId` parameters with the securely authenticated `uid`.
