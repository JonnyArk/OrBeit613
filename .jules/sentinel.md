## 2024-05-29 - Missing Authentication on Firebase Functions

**Vulnerability:** Firebase Cloud Functions `onRequest` endpoints (`creditUsage`, `generateAsset`, `distillContext`) lacked manual authentication checks, allowing unauthenticated access.
**Learning:** By default, Firebase `onRequest` endpoints do not verify authentication automatically like callable functions (`onCall`). This is a common architectural gap.
**Prevention:** Always explicitly use the custom `requireAuth` helper and structural typing for HTTP endpoints exposed to the public via `onRequest`.
