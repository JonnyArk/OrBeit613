## 2024-05-18 - Prevent IDOR in onRequest v2 Functions
**Vulnerability:** IDOR vulnerability and missing authentication on public onRequest endpoints.
**Learning:** `onRequest` does not automatically verify authentication tokens (unlike `onCall`), allowing any user to pass arbitrary `userId` payloads.
**Prevention:** Always verify token explicitly in `onRequest` endpoints and strictly overwrite payload identity with the server-side extracted UID.
