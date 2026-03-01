## 2024-05-24 - Unauthenticated Access to AI Resources via onRequest

**Vulnerability:** Core backend services consuming expensive AI credits (`generateAsset`, `distillContext`, `creditUsage`) were exposed publicly as `onRequest` endpoints instead of authenticated `onCall` functions. This allowed unauthorized users to potentially consume the 25,000 monthly Google AI Ultra credit allocation, bypass intended usage limitations, and spoof user identities by manually providing a `userId` in the payload. Furthermore, the public `healthCheck` endpoint exposed internal credit usage statistics to any requester.

**Learning:** In Firebase Cloud Functions, `onRequest` functions expose a public HTTP URL with no built-in authentication, leaving authorization checks up to the developer (which were missing). When `onCall` is used, the Firebase Client SDK automatically manages authentication, and `request.auth` becomes safely populated by Firebase. Also, client-provided IDs must never be blindly trusted; `userId` should be derived server-side from `request.auth.uid`.

**Prevention:**
1. Default to `onCall` (callable functions) for any endpoint serving authenticated clients.
2. Explicitly verify `if (!request.auth)` in every callable function dealing with sensitive data or billed resources.
3. Never trust client-provided `userId` parameters; strictly inject `request.auth.uid` for tracking or acting on a user's behalf.
4. Keep public `onRequest` functions strictly for webhooks, anonymous public endpoints, or simple health checks, and ensure they never leak internal business metrics.