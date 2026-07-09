## YYYY-MM-DD - [Authentication Bypass & Info Leak in Cloud Functions]
**Vulnerability:** [AI services endpoints (`generateAsset`, `distillContext`, `creditUsage`) were accessible without authentication and exposed internal error stack traces.]
**Learning:** [Missing explicit CORS and authentication checks on `onRequest` endpoints can lead to unauthorized access and resource abuse, and returning raw error messages violates fail securely principles.]
**Prevention:** [Wrap all sensitive `onRequest` functions in an auth/CORS middleware (like `withAuth`) and sanitize error responses to not leak internal details.]
