## 2024-05-18 - Replacing iterative client-side aggregation with Firestore server-side sum
**Learning:** In the `functions/` backend, using `.get()` to iterate over documents and calculate a sum in memory is inefficient. This transfers all matching documents over the network and processes them in Node.js, leading to high latency and memory usage.
**Action:** Use Firestore's server-side aggregation `AggregateField.sum()` to compute totals directly on the database server, returning only the final sum to the client.
