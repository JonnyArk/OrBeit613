## 2024-06-05 - Missing Authentication on Cloud Functions
**Vulnerability:** The `generateAsset` and `distillContext` functions in `functions/src/index.ts` lack authentication.
**Learning:** These endpoints handle sensitive AI resource generation (Google AI Ultra) and process personal context data. While they have secrets configured for Google AI, they do not verify if the client making the request is an authenticated OrBeit user. This allows unauthenticated attackers to consume AI credits and potentially use the service maliciously.
**Prevention:** Always implement authentication checks on endpoints that perform state-changing operations or consume paid resources, especially those exposed as public `onRequest` functions.
