## 2025-09-25 - Missing Authentication and IDOR on HTTP Endpoints
**Vulnerability:** Firebase Cloud Functions v2 `onRequest` HTTP endpoints lacked authentication checks and trusted client-provided user IDs, allowing unauthorized access and potential Insecure Direct Object Reference (IDOR).
**Learning:** `onRequest` endpoints do not have built-in authentication context like `onCall`. Relying on client-supplied identifiers without server-side validation is unsafe.
**Prevention:** Always manually extract and verify the Bearer token using `getAuth().verifyIdToken()` in `onRequest` endpoints. Overwrite request payloads' user IDs with the verified `uid` to prevent IDOR.
