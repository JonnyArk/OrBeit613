## 2026-05-31 - Server-side vs Client-side Firestore Aggregation
**Learning:** Calculating sums across a Firestore collection by pulling all documents down and iterating them client-side causes massive unnecessary document reads, uses significant memory and network bandwidth.
**Action:** Always prefer importing `AggregateField` from `firebase-admin/firestore` and using server-side aggregation `.aggregate({ [alias]: AggregateField.sum('fieldName') })` when calculating sums, which is far more efficient.
