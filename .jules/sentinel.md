## YYYY-MM-DD - Missing Authentication on Costly AI Endpoints
**Vulnerability:** Found unauthenticated Cloud Functions (`generateAsset` and `distillContext`) consuming limited Google AI Ultra credits, leading to an abuse/cost-exhaustion risk.
**Learning:** Functions that consume metered resources or manage credits must always be protected with a `withAuth` wrapper (using `cors` to ensure OPTIONS preflight requests aren't blocked).
**Prevention:** Always implement and enforce Firebase IdToken verification on `onRequest` functions that trigger AI models or other costly services.
