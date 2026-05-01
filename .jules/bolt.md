## 2024-05-01 - Firestore Aggregations
**Learning:** In the Firebase codebase, when calculating aggregations (like monthly credit usage), avoid querying and summing individual raw log collections to prevent unbounded O(N) reads and high memory usage.
**Action:** Instead of relying on manually maintained aggregate documents or client-side summing, use Firestore's native `aggregate` query API (e.g., `AggregateField.sum()`) to efficiently calculate server-side totals.
