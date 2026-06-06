## 2026-06-06 - Firestore Server-Side Aggregation
**Learning:** Client-side iteration for sums across large Firestore collections can cause severe memory bloat and slow response times due to fetching every document.
**Action:** Always prefer server-side aggregation (`AggregateField.sum`) over client-side iteration to keep complexity at O(1) reads instead of O(n) document reads.
