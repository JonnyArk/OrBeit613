## 2024-05-18 - Optimize Firestore Aggregations
**Learning:** In the Firebase codebase, when calculating aggregations (like monthly credit usage), avoid querying and summing individual raw log collections to prevent unbounded O(N) reads.
**Action:** Instead of relying on manually maintained aggregate documents which require reliable write-side triggers to avoid functional regressions, use Firestore's native `aggregate` query API (e.g., `AggregateField.sum()`) to efficiently calculate server-side totals.
