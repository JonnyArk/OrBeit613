## 2024-05-24 - Server-side Firestore Aggregation
**Learning:** Calculating sums across a Firestore collection in the backend using client-side iteration (like `.get()` then `.forEach()`) is inefficient, transferring unnecessary data and consuming memory.
**Action:** Prefer server-side aggregation. Import `AggregateField` from `firebase-admin/firestore` and use `.aggregate({ [alias]: AggregateField.sum('fieldName') })`.
