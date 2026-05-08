## 2024-05-08 - Use Firestore Aggregate API for large sums
**Learning:** Avoid querying and summing individual raw log collections to calculate aggregations, as it causes unbounded O(N) reads.
**Action:** Use Firestore's native aggregate query API (e.g., `AggregateField.sum()`) to efficiently calculate server-side totals.
