## 2024-06-10 - Server-Side Aggregation for Firestore
**Learning:** Client-side iteration over large Firestore query results can cause OOM errors and significant memory overhead, particularly when accumulating simple sums.
**Action:** Always prefer `AggregateField.sum()` from `firebase-admin/firestore` for server-side sum aggregations instead of downloading all documents and accumulating in memory.
