## 2024-10-09 - Flattening Heterogeneous Lists in Flutter
**Learning:** Eagerly instantiating heterogeneous lists (mixing headers and items) inside a `ListView` breaks virtualization and creates performance bottlenecks as lists grow.
**Action:** Always flatten heterogeneous data models into a single `List<Object>` and use `ListView.builder` with `switch` pattern matching to render widgets on demand.
