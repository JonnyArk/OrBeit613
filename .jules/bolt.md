## 2024-06-02 - Server-side Aggregation in Firestore
**Learning:** Firestore supports `AggregateField.sum` natively to perform server-side aggregations. Querying all documents to manually sum a field client-side causes unnecessary memory overhead and network latency, especially for unbounded time-series queries like monthly usage.
**Action:** Always prefer `.aggregate({ [alias]: AggregateField.sum('fieldName') })` over fetching full collections or document lists when calculating sums across a Firestore collection in the backend.
