## 2024-04-18 - ListView Virtualization Pattern
**Learning:** Transitioning from an eager `ListView` to a virtualized `ListView.builder` for grouped structures requires flattening nested data into a heterogeneous list using sealed classes. This preserves existing logic like per-group staggered animation timing via local index counters, without sacrificing maintainability.
**Action:** Default to flat lists + `sealed class` + `ListView.builder` when rendering long, dynamically grouped content.
