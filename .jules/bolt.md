## 2024-10-01 - Optimizing Firestore Aggregations
**Learning:** In Firestore, computing sums across collections (like monthly credit usage) requires an O(N) query that degrades performance as data grows. The getMonthlyUsage method was performing an O(N) query on every credit check, creating a significant bottleneck.
**Action:** Always maintain pre-computed aggregates in a separate document for O(1) reads. Ensure write-paths increment the aggregate, and read-paths fetch the aggregate with a fallback to the O(N) query if the aggregate doesn't exist yet.
