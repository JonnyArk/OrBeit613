## 2024-05-18 - Avoid O(N) reads with Firestore aggregations
**Learning:** Calculating aggregations (like monthly usage) by querying and summing individual raw log collections leads to unbounded O(N) reads, high latency, and massive memory overhead. Relying on manually maintained aggregate docs can cause regressions if write-side triggers fail.
**Action:** Use Firestore's native `aggregate` query API (`AggregateField.sum()`) to efficiently calculate server-side totals with O(1) document read cost equivalent and minimal network payload.
