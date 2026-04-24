## 2025-04-24 - Missing Authentication on Sensitive HTTP Functions
**Vulnerability:** The HTTP Firebase Cloud Functions `generateAsset` and `distillContext` lack authentication, allowing any unauthorized entity to call these APIs and potentially abuse AI credits.
**Learning:** These endpoints used Firebase `onRequest` without implementing authorization checks, likely because they process internal app traffic, but `onRequest` functions are publicly exposed by default.
**Prevention:** Always implement `requireAuth` or native Firebase authentication checking logic for any HTTP endpoint that handles sensitive data or consumes billable resources. Securely inject the user ID into the server-side logic from the verified token.
