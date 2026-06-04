## 2026-06-04 - Use server-side aggregation for Firestore queries
**Learning:** Calculating sums of document fields client-side using `forEach` over a collection pull is highly inefficient as it incurs large memory overhead and unnecessary document transfer.
**Action:** Always prefer `AggregateField.sum()` and `.aggregate()` to perform summation server-side and fetch only the result.
