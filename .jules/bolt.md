## 2026-06-24 - Firestore O(N) Query Replacement
**Learning:** Querying the entire usage collection to calculate the sum using `.forEach()` memory aggregation introduces an O(N) cost that grows linearly throughout the month and limits scalability in Firebase Functions.
**Action:** Always utilize pre-calculated aggregate documents when reading sums (like the existing `updateMonthlyAggregate` method does) for O(1) reads.
