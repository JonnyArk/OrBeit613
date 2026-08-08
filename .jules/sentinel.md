## YYYY-MM-DD - [Authentication Bypass in REST Endpoints]
**Vulnerability:** [Firebase Cloud Functions v2 onRequest endpoints lacked token validation]
**Learning:** [onRequest endpoints do not automatically verify Firebase Authentication tokens, and need explicit token validation via getAuth().verifyIdToken]
**Prevention:** [Implement explicit token validation for sensitive onRequest endpoints or convert them to onCall if clients are updated]
