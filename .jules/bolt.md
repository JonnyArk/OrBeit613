## 2024-05-24 - Server-side Aggregation for Firestore Analytics
**Learning:** When calculating totals (like credit usage) across a large Firestore collection, fetching all documents via `.get()` and iterating client-side introduces severe memory and bandwidth bottlenecks as the dataset grows.
**Action:** Always prefer server-side aggregation (e.g., `aggregate({ total: AggregateField.sum('fieldName') })`) from `firebase-admin/firestore`. It pushes the computation to the database, significantly reducing the amount of data transferred and lowering latency and memory footprint.
