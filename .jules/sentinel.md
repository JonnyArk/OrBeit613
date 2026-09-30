## 2024-09-30 - Fix Missing Authentication and IDOR in v2 HTTP Endpoints
**Vulnerability:** v2 onRequest cloud functions were missing authentication checks, allowing unauthenticated access and potential IDOR if clients supplied arbitrary user IDs in the payload.
**Learning:** In Firebase Cloud Functions v2, onRequest HTTP endpoints lack the built-in authentication context provided by onCall. Developers must manually extract and verify the Bearer token and explicitly override payload user IDs with the authenticated token's UID to prevent IDOR.
**Prevention:** Always use onCall for authenticated endpoints when possible. When using onRequest, manually verify request.headers.authorization using firebase-admin/auth and forcefully overwrite client-provided user identities.
