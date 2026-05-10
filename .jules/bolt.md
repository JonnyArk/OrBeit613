## 2026-05-10 - Firestore Aggregations
**Learning:** When calculating totals (like credit usage) in Firestore, iterating over individual documents on the client-side causes an O(N) performance bottleneck as data grows.
**Action:** Always use Firestore's native `AggregateField.sum()` (or similar aggregate queries) for O(1) server-side aggregation to avoid downloading large numbers of documents.
