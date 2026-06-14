## 2025-02-14 - Optimize Firestore Accumulation Queries
**Learning:** Client-side iteration for aggregate totals is a bottleneck as collections grow since it transfers and processes the entire result set in memory, violating O(1) performance scalability in large datasets.
**Action:** Use server-side aggregation (`.aggregate({ [alias]: AggregateField.sum('fieldName') })`) so the database returns a single calculated scalar value.
