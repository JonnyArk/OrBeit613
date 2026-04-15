## 2026-04-15 - Eager Heterogeneous List Anti-Pattern
**Learning:** Using `ListView` with spread operators (`...`) and loops inside `children` for heterogeneous lists (grouped sections, headers) eagerly instantiates all widgets in memory, bypassing Flutter's virtualization and causing main-thread stuttering for long lists.
**Action:** Always flatten grouped data structures into a single array of typed objects (e.g., using an enum like `_ListItemType`) and pass it to `ListView.builder` or `SliverList` to ensure true O(1) memory rendering and lazy loading while preserving complex UI layouts.
