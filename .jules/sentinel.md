## YYYY-MM-DD - [Missing Authentication on AI Endpoints]
**Vulnerability:** The AI endpoints (like generateAsset) were missing authentication checks.
**Learning:** Anyone could potentially call the endpoint and drain AI credits, causing financial loss.
**Prevention:** Always require authentication on endpoints that consume expensive resources or interact with user data.
