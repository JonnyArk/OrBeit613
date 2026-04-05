## 2025-02-05 - Missing Authentication and IDOR in AI Endpoints
**Vulnerability:** The AI endpoints `creditUsage`, `generateAsset`, and `distillContext` were publicly exposed without authentication checks. In addition, the AI service functions trusted the `userId` passed in the request body, which allowed for Identity Insecure Direct Object Reference (IDOR) attacks, enabling users to spoof actions as others.
**Learning:** When transitioning endpoints to normal HTTP `onRequest` functions rather than `onCall`, standard Firebase auth context (`request.auth`) is unavailable.
**Prevention:** Use standard authorization header verification (`getAuth().verifyIdToken()`) and overwrite the client payload with the verified `uid`.
