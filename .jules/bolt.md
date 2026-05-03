
## 2025-02-23 - Firebase Collection Aggregations
**Learning:** Fetching and summing individual documents in Firestore leads to O(N) read operations and slower responses.
**Action:** Always use `AggregateField.sum()` for server-side aggregation calculations in Firebase Admin SDK.
