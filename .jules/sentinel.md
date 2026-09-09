## 2026-02-05 - Add Authentication to Sensitive Endpoints
**Vulnerability:** Unauthenticated access to Firebase Cloud Functions `healthCheck`, `creditUsage`, `generateAsset`, and `distillContext`.
**Learning:** These endpoints are exposed directly to the internet without requiring any authentication or authorization token. This allows anyone to query system health, retrieve business logic statistics, and trigger expensive AI operations that could lead to billing exhaustion or denial of service.
**Prevention:** Implement Firebase Authentication checks for all sensitive API endpoints via the `Request` object before processing incoming requests.
