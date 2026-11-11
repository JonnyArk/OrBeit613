## 2026-02-05 - Missing Authentication on Credit-Consuming Endpoints
**Vulnerability:** The `generateAsset` and `distillContext` Firebase Cloud Functions were publicly accessible without any authentication checks, yet they consumed limited AI monthly credits (25000/month).
**Learning:** In a serverless architecture where endpoints proxy paid external APIs (like Google AI Ultra), any unauthenticated endpoint acts as an unprotected bridge, creating a severe Denial of Wallet and Resource Exhaustion vector.
**Prevention:** All Firebase HTTPS `onRequest` endpoints that consume restricted resources must explicitly implement Bearer token verification using `getAuth().verifyIdToken()` wrapped in a secure `try...catch` block.
