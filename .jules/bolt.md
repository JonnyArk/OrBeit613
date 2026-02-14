## 2026-02-14 - Task List Virtualization
**Learning:** Eager loading `ListView(children: ...)` with complex list items (animations, swipe actions) causes significant startup delay and memory pressure for large lists. `ListView.builder` or `CustomScrollView` with `SliverList` enables virtualization (lazy loading).
**Action:** Always prefer `CustomScrollView` + `SliverList` (or `ListView.builder`) for potentially long or complex lists to ensure scalability and smooth scrolling.
