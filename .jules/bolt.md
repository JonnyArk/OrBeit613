
## 2025-02-14 - Replace O(N) Firestore Queries with O(1) Aggregate Reads
**Learning:** The `getMonthlyUsage` method in `AIManager` used an O(N) query across the usage collection to calculate the sum of credits used. Because this method is indirectly called inside the `healthCheck` endpoint (via `getUsageSummary()`), the read volume scaled linearly with usage, causing unnecessary latency and Firestore read costs. We were already computing `totalUsed` dynamically in the `metadata/credits/monthly/{monthKey}` document via `updateMonthlyAggregate()`.
**Action:** Always prefer O(1) reads of pre-calculated aggregates instead of summing documents dynamically at runtime, especially on frequently accessed endpoints like health checks.
