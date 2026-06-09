## 2025-06-09 - Server-side Aggregation
**Learning:** For calculating sums across a Firestore collection, client-side iteration over documents transferred via network can be a major performance and memory bottleneck.
**Action:** Always prefer server-side aggregation by using `AggregateField.sum()` from `firebase-admin/firestore`.
