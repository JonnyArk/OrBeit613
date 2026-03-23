## 2024-03-24 - [Derived State Recomputation]
**Learning:** Computing grouped/filtered state dynamically in getters within a widget's build cycle (O(N) operations) creates unnecessary processing overhead, especially for larger lists.
**Action:** Memoize derived state (e.g. grouped lists) directly into the widget's state during async data loads, keeping `build()` purely for rendering. Ensure correct structure and types are preserved.
