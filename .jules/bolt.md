## 2024-05-23 - Optimize Firestore aggregations
**Learning:** Firestore queries over collections can become O(N) performance bottlenecks as datasets grow. Using pre-computed aggregate documents enables O(1) lookups, saving significant read operations and improving response times.
**Action:** Always prefer reading from pre-computed summary documents rather than performing real-time aggregations over large collections. Update the summaries atomically when the underlying data changes.
