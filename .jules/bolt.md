## 2024-06-11 - Server-side Aggregation
**Learning:** For calculating sums across a Firestore collection, client-side iteration over documents is slow and expensive. Server-side aggregation is much faster and reduces memory overhead and bandwidth.
**Action:** Use server-side aggregation (`AggregateField`) for calculating sums or averages across large datasets in Firestore.
