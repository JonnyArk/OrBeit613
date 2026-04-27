## 2024-04-27 - Firestore Server-side Aggregations
**Learning:** Calculating aggregations (like monthly credit usage) by querying and summing individual raw log collections leads to unbounded O(N) reads. Relying on manually maintained aggregate documents requires reliable write-side triggers to avoid functional regressions.
**Action:** Use Firestore's native aggregate query API (e.g., `AggregateField.sum()`) to efficiently calculate server-side totals.
