## 2025-02-23 - Missing Authentication on Cloud Functions
**Vulnerability:** HTTP Cloud Functions exposing expensive AI quotas without authentication or authorization checks.
**Learning:** Functions that don't verify auth tokens implicitly allow any internet user to execute them. Combining CORS headers with an auth verification wrapper prevents abuse and pre-flight CORS failures.
**Prevention:** Ensure every HTTP cloud function is wrapped with an authentication middleware that validates a token before execution.
