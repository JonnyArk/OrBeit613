## 2025-04-09 - AI Service Unauthorized Access and Spoofing
**Vulnerability:** AI endpoints (`generateAsset`, `distillContext`) lacked authentication checks and trusted client-provided `userId` payloads.
**Learning:** `onRequest` functions in Firebase are fully public by default. If they perform billing-sensitive operations (like generating AI resources) or require user attribution, they must implement manual authorization header verification and securely derive the `uid` from the verified token, overwriting any client data.
**Prevention:** Always use `requireAuth` (or convert to `onCall` where feasible) to validate the Firebase ID Token for sensitive HTTP endpoints. Never trust `userId` passed in `request.body`.
