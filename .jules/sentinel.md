## 2026-06-29 - Missing Authentication on HTTP Endpoints
**Vulnerability:** The generateAsset endpoint in Cloud Functions lacked authentication, allowing unauthenticated public access.
**Learning:** onRequest functions do not inherently inherit Firebase Security Rules. When securing these with custom auth, we must wrap them with cors to ensure preflight OPTIONS requests pass, and we must securely handle inner async errors to prevent unhandled promise rejections.
**Prevention:** Always combine requireAuth middleware with a cors wrapper inside onRequest functions that interact with browser clients, and ensure all async logic is enclosed in a try/catch block.
