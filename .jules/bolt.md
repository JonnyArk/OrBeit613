## 2026-05-28 - O(1) Aggregate Reads for Usage Analytics
**Learning:** Querying an entire collection and summing up values in memory results in an O(N) operation (N reads, higher latency) where a pre-calculated aggregate document exists (O(1) read).
**Action:** Always prefer reading maintained aggregate documents over performing manual summation via collection scans for analytics dashboards.
