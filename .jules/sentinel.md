## 2024-10-24 - Missing authentication on Firebase HTTP functions
**Vulnerability:** Found unauthenticated Firebase Cloud Functions v2 `onRequest` HTTP endpoints, allowing public access to sensitive data and resource-intensive AI actions.
**Learning:** By default, Firebase `onRequest` endpoints do not have built-in authentication context (unlike `onCall` functions). They require explicit Bearer token validation using the Firebase Admin SDK.
**Prevention:** Always manually extract and verify the `Authorization` header on all non-public `onRequest` endpoints, returning `401` on missing or invalid tokens, or switch to `onCall` where feasible.
