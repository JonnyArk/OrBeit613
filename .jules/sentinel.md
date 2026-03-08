## YYYY-MM-DD - AI Service Authentication Bypass
**Vulnerability:** The AI services (`generateAsset`, `distillContext`, `creditUsage`) exposed via public `onRequest` HTTP endpoints lack any authentication or authorization checks.
**Learning:** This exposes the AI credits and backend services to anyone on the internet, allowing credit exhaustion and unauthorized use.
**Prevention:** Always implement `admin.auth().verifyIdToken()` for manual authorization header verification on `onRequest` endpoints instead of relying on `onCall` when client API contract must be preserved.
