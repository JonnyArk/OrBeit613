## 2025-02-23 - Virtualized Grouped Lists
**Learning:** Using an eager `ListView` for grouped list sections with headers causes full-tree rendering.
**Action:** Flatten the grouped map/tree into a single array using a wrapper class (`_TaskListItemType`) and render using `ListView.builder`.
