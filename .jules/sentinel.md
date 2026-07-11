## YYYY-MM-DD - Missing Authentication on Cloud Functions
**Vulnerability:** Firebase Cloud Functions onRequest endpoints lacked manual token verification despite accessing sensitive operations (AI usage, asset generation).
**Learning:** onRequest functions accessed by clients need a manual CORS middleware wrapper encompassing a secure try/catch and manual getAuth().verifyIdToken() verification to secure them from unauthorized access without blocking preflight OPTIONS requests.
**Prevention:** Always wrap client-facing onRequest endpoints with a custom authentication and CORS middleware (like withAuth) when authorization is required.
