## 2026-08-23 - Lazy Loading ListView Optimization
**Learning:** Eagerly built `ListView` causes O(N) upfront allocations and staggered unbounded animation delays can keep lazily loaded off-screen items invisible.
**Action:** Flatten data models for `ListView.builder` and cap index multipliers for animation delays when virtualizing heterogenous lists.
