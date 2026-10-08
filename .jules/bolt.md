## 2024-10-08 - Virtualize heterogeneous lists in Flutter

**Learning:** When using `ListView` with a large number of heterogeneous children (like nested loops of sections and headers), Flutter eagerly builds all widgets, which causes a performance bottleneck.
**Action:** Flatten the underlying data models into a single linear list (e.g., `List<Object>`) and use Dart 3 pattern matching inside `ListView.builder` to lazily construct the appropriate widget on demand.
