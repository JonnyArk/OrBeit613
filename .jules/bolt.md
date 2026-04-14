## 2025-05-18 - Virtualization for Task List Panel
**Learning:** Eagerly rendering a ListView with potentially many tasks can cause significant performance bottlenecks due to excessive layout passes and memory usage.
**Action:** Always prefer `ListView.builder` over `ListView` for long or potentially unbounded lists in Flutter, flattening any nested grouping data structures into a single list of view models first.
