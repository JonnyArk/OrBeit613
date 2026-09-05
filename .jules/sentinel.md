## 2026-09-05 - [Missing Authentication in onRequest Functions]
**Vulnerability:** The HTTP Cloud Functions exposed via onRequest did not verify the user's authentication token, allowing arbitrary unauthenticated access and potential IDOR by spoofing the userId in the payload.
**Learning:** By default, Firebase Functions v2 onRequest endpoints are publicly accessible and do not automatically enforce authentication.
**Prevention:** Always manually extract the Authorization header and verify the bearer token using getAuth().verifyIdToken() from firebase-admin/auth for sensitive v2 HTTP endpoints, and override client-provided user IDs with the verified token's uid.
