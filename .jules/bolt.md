## 2024-05-24 - Server-Side Aggregation for Firestore Summation
**Learning:** Client-side iteration for calculating aggregations (like sums) on large Firestore collections causes a severe N+1 memory/bandwidth bottleneck in Cloud Functions. Downloading every document to tally a field is a major anti-pattern in Firebase that scales poorly.
**Action:** Always prefer Firebase's native `AggregateField` (e.g., `AggregateField.sum('field')`) and use server-side aggregation for summary operations to reduce network payload to O(1).
