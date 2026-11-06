## 2024-11-06 - Optimize heterogeneous lists with lazy closures
**Learning:** Eagerly instantiating mixed items (headers + content) in a standard `ListView` causes performance bottlenecks on large lists due to synchronously building all children.
**Action:** When converting `ListView` with mixed elements to `ListView.builder`, map the data into a list of lightweight closures (e.g., `List<Widget Function()>`) synchronously in `build()` and pass them to `itemBuilder` to preserve lazy rendering without needing parallel mutable state.
