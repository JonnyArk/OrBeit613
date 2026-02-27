## Sentinel's Journal

## 2026-02-05 - Auth Bypass & IDOR in AI Functions
**Vulnerability:** The AI endpoints `generateAsset` and `distillContext` were exposed as public `onRequest` HTTP functions without authentication checks. They relied on client-supplied `userId` from the request body.
**Learning:** Using `onRequest` for internal app logic creates a dual risk: unauthorized resource consumption (DoS/Financial) and Insecure Direct Object References (IDOR), as attackers can spoof `userId` to modify other users' data.
**Prevention:** Use `onCall` for all client-facing functions. This enforces Firebase Auth token verification automatically. Always use `request.auth.uid` as the source of truth for user identity, never trust the request body for sensitive identifiers.
