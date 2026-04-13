## 2026-04-13 - Virtualizing Heterogeneous Flutter Lists
**Learning:** Virtualizing grouped lists (like task boards with headers and items) using `ListView.builder` requires flattening the structured data into a single 1D array using a wrapper class with an explicit type enum (e.g., `_TaskListItemType`).
**Action:** Always flatten hierarchical data models into a unified 1D list of wrapped items before passing to `ListView.builder` or `SliverChildBuilderDelegate` to enable true lazy loading while preserving complex UI structures.
