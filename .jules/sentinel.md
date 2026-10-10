## 2024-10-10 - Missing Authentication Context in Firebase onRequest Functions
**Vulnerability:** Firebase Cloud Functions v2 onRequest endpoints lacked authentication and trusted client-provided user IDs, leading to unauthorized access and IDOR vulnerabilities.
**Learning:** Unlike onCall functions, onRequest HTTP endpoints in Firebase v2 do not automatically parse or provide authentication context.
**Prevention:** Always manually extract the Bearer token from request.headers.authorization, verify it using getAuth().verifyIdToken(), and strictly overwrite client-provided user IDs with the verified token UID.
