## 2025-01-29 - Firestore Aggregate Query Optimization
**Learning:** The AIManager in this codebase already maintains an O(1) aggregate document at `metadata/credits/monthly/${monthKey}` via `updateMonthlyAggregate`, but `getMonthlyUsage` was unnecessarily performing an O(N) scan on the `metadata/credits/usage` collection.
**Action:** Always check if a Firestore aggregate document is maintained (e.g., using `FieldValue.increment`) before writing or relying on O(N) query scans. When migrating to an aggregate, include a fallback to the original query for historical data.
