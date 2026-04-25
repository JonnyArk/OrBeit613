## 2025-02-23 - Firebase Aggregation Optimization
**Learning:** O(N) reads for monthly usage summaries in Firebase functions cause severe latency and cost spikes because `getMonthlyUsage` queried the entire raw log collection instead of reading the pre-computed atomic aggregate document.
**Action:** When calculating aggregations, always prefer reading the pre-calculated atomic aggregate documents (e.g., `metadata/credits/monthly/{monthKey}`) directly over querying and summing individual raw log collections.
