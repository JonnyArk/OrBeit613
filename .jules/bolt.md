## 2025-06-08 - Server-side Aggregation in Firestore
**Learning:** Fetching many documents for client-side aggregation (like sum) is inefficient and can cause memory/latency issues as collections grow.
**Action:** Always prefer server-side aggregations using `AggregateField` in Firestore to keep payload size O(1) and improve latency.
