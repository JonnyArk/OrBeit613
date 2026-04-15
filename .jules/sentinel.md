## 2025-04-15 - Prevent IDOR/Spoofing in Firebase Cloud Functions
**Vulnerability:** The AI endpoints `generateAsset` and `distillContext` trusted the client-provided `userId` in the request body for tracking credit usage and attributing events, which could allow users to spoof identities and consume other users' quotas or access their data.
**Learning:** Firebase `onRequest` functions do not automatically verify user identities like `onCall` does. If custom authentication is not strictly enforced, any client payload can be forged.
**Prevention:** Always verify the Firebase ID token manually using `getAuth().verifyIdToken()` on `onRequest` endpoints and inject the resulting `uid` directly into the payload, ignoring any client-provided ID.
