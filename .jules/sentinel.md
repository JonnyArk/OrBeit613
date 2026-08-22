## 2026-08-22 - Securing Unauthenticated onRequest Endpoints & IDOR
**Vulnerability:** Firebase Cloud Functions (v2) `onRequest` endpoints lacked authentication, allowing unauthorized credit drain, and accepted client-provided user IDs which introduced IDOR risks.
**Learning:** `onRequest` functions in v2 do not automatically enforce auth. Trusting client-provided user IDs as a fallback in sensitive API calls bypasses proper authorization limits.
**Prevention:** Always manually extract and verify the `Authorization` bearer token using `firebase-admin/auth`. Strictly overwrite any payload user IDs with the verified server-side identity.
