## 2026-02-05 - [CRITICAL] Unauthenticated AI Endpoints

**Vulnerability:** The AI service endpoints (`generateAsset`, `distillContext`, `creditUsage`) were exposed as public HTTP Cloud Functions (`onRequest`) without authentication or input validation. This allowed any unauthenticated user to consume expensive AI credits (Google AI Ultra), generate content, and access business metrics (credit usage) by simply sending a POST/GET request. Additionally, the `healthCheck` endpoint leaked sensitive credit usage data.

**Learning:** When using `firebase-functions/v2`, `onRequest` creates public HTTP endpoints by default. Unlike `onCall`, it does not automatically handle authentication contexts. Developers often mistake `onRequest` for a secured API endpoint or assume obscure URLs provide security (security by obscurity).

**Prevention:**
1. Default to `onCall` (Callable Functions) for client-facing APIs, as they automatically provide `request.auth` context and handle serialization.
2. If `onRequest` is necessary (e.g., for webhooks or public monitoring), explicitly validate `request.headers.authorization` or implement API key checks.
3. Never expose internal business metrics (like credit usage or costs) in public health check endpoints.
4. Always validate that the `userId` in the request body matches the authenticated `request.auth.uid` to prevent IDOR (Insecure Direct Object Reference).
