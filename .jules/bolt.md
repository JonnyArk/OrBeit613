## 2025-02-24 - Firestore Aggregate Reads
**Learning:** Querying and summing large collections in Firestore for aggregations (like monthly usage) causes unbounded O(N) reads, leading to high latency and database costs. The codebase correctly maintains aggregate documents (e.g., `metadata/credits/monthly/{monthKey}`) atomically, but was failing to utilize them for reading.
**Action:** Always prefer reading pre-calculated aggregate documents (O(1)) over querying and iterating over individual log documents (O(N)), especially in high-traffic paths like credit checks.
