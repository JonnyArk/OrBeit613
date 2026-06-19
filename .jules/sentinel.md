## 2024-06-19 - Missing Authentication on Firebase HTTPS Functions
**Vulnerability:** Firebase `onRequest` HTTP functions (`healthCheck`, `creditUsage`, `generateAsset`, `distillContext`) were completely unauthenticated, allowing any user to invoke them and consume AI resources (secrets were exposed to the function, but not the client, though AI usage was exposed).
**Learning:** `onRequest` functions must be manually authenticated, unlike `onCall` functions which automatically include auth context. Combining this with CORS preflight requests means `requireAuth` must run inside the CORS handler callback.
**Prevention:** Always wrap browser-facing `onRequest` endpoints with a CORS handler and implement manual token verification (e.g. `getAuth().verifyIdToken()`) inside the callback.
