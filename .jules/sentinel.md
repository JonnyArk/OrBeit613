## YYYY-MM-DD - Missing authentication on sensitive endpoints
**Vulnerability:** Found unauthenticated Cloud Functions (`generateAsset` and `distillContext`) that call costly external AI models.
**Learning:** Functions that wrap paid external services must require user authentication, otherwise they can be abused leading to high bills and quotas exhaustion.
**Prevention:** Always wrap cloud functions with authentication and CORS logic.
