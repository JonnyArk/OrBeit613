## 2024-05-29 - Server-Side Aggregation for Firestore
**Learning:** Client-side iteration for calculating sums across Firestore collections is an O(N) performance bottleneck because it downloads every document to the Cloud Function memory.
**Action:** Always prefer server-side aggregation using `AggregateField.sum` from `firebase-admin/firestore` to compute sums efficiently without transferring bulk document data.
