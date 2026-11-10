## 2026-11-10 - Missing Authentication on AI Endpoints
**Vulnerability:** Firebase onRequest HTTP endpoints (generateAsset, distillContext, creditUsage) were completely unauthenticated, allowing any external actor to consume AI credits.
**Learning:** In this architecture, Firebase HTTP functions do not automatically enforce authentication. A reusable pattern (verifyAuth) wrapping getAuth().verifyIdToken() in a try...catch is required to protect these endpoints while preventing unhandled promise rejections.
**Prevention:** Always implement the verifyAuth helper on new onRequest endpoints unless they are explicitly intended to be public (like healthCheck).
