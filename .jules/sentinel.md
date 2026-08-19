## 2026-02-05 - Missing Authentication on API Endpoints
**Vulnerability:** Publicly accessible cloud functions (e.g. `generateAsset`, `distillContext`) accepted user ID from the unauthenticated request body, creating an IDOR vulnerability.
**Learning:** Always verify identity server-side via authentication tokens rather than trusting client-provided payloads.
**Prevention:** Extract and strictly overwrite the payload user ID with the verified identity from the server-side authentication token in all endpoints processing user-scoped data.
