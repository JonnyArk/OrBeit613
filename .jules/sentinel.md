## 2024-05-24 - Missing Authentication on Sensitive Endpoints
**Vulnerability:** The `generateAsset` and `distillContext` functions process sensitive data and consume AI credits without any authentication checks, allowing unauthorized users to access them.
**Learning:** Firebase `onRequest` HTTP functions are open to the public by default. Earning authentication requires verifying Firebase Auth tokens. In a browser-accessed environment, manual authentication validation must happen inside a CORS middleware block to avoid blocking pre-flight requests.
**Prevention:** Always wrap sensitive `onRequest` functions with authentication validation logic. Make sure to integrate this logic properly within CORS callbacks.
