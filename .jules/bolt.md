## 2024-09-30 - O(1) Aggregate Reading
**Learning:** Found an O(N) Firestore collection scan for calculating monthly credit usage in getMonthlyUsage, despite an existing O(1) aggregate document being continuously updated via updateMonthlyAggregate.
**Action:** Always verify if a pre-calculated aggregate exists before performing linear scans for metrics or summaries in Firestore.
