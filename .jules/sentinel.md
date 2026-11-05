## 2024-11-05 - Fix unauthenticated sensitive endpoints
**Vulnerability:** The `creditUsage`, `generateAsset`, and `distillContext` Cloud Functions were exposed without any authentication checks, allowing anyone to trigger AI generation and exhaust the monthly AI credits.
**Learning:** The endpoints were likely left unauthenticated during development or initial implementation. It's crucial to always secure sensitive endpoints, especially those that interact with external services or incur costs.
**Prevention:** Implement a robust `verifyAuth` helper that securely validates Firebase ID tokens via the `Authorization: Bearer <token>` header without leaking internal stack traces. Protect sensitive endpoints while intentionally leaving `healthCheck` public for load balancer access.
