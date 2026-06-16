## 2024-05-24 - Firestore Client-Side Iteration Bottleneck
**Learning:** Client-side iteration for computing sums over large Firestore collections (like monthly usage logs) causes severe memory and latency bottlenecks because it transfers every document over the network to the server function.
**Action:** Always prefer server-side aggregation using `AggregateField.sum()` to compute totals directly in the database and drastically reduce data payload sizes and memory consumption.
