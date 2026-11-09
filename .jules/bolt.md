## 2024-03-24 - Cache health check endpoints
**Learning:** Health check endpoints which retrieve usage stats or do database queries can be unnecessarily hit repeatedly by uptime monitors. Without caching, each ping consumes backend resources.
**Action:** Adding a short `Cache-Control` header (e.g. 15-30 seconds) on unauthenticated `healthCheck` endpoints provides a quick response to repeated pings by CDNs and proxies while significantly reducing unnecessary database queries and cold start costs.
