## 2025-02-18 - Replace Client-Side Iteration With Server-Side Aggregation
**Learning:** In the `AIManager` when getting monthly usage, calculating the total by iterating over all document snapshots in the client consumes unnecessary bandwidth and memory, especially as the number of requests grows.
**Action:** Use Firestore's server-side aggregation feature with `AggregateField.sum()` to compute the total directly on the database server.
