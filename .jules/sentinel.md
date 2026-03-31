## 2026-02-05 - Missing Authentication on AI HTTP Endpoints
**Vulnerability:** The AI endpoints (generateAsset, distillContext, creditUsage) were exposed publicly via HTTP (onRequest) without any authentication or authorization checks.
**Learning:** This existed because onRequest endpoints do not automatically verify user tokens unlike onCall endpoints, requiring manual validation of the Authorization header to prevent unauthorized access and potential resource exhaustion (API credits).
**Prevention:** Always extract and verify the Authorization token using getAuth().verifyIdToken() on all sensitive onRequest endpoints, and securely inject the authenticated uid into the payload to prevent IDOR vulnerabilities.
