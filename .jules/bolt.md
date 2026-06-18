## 2024-06-18 - Optimize task list grouping performance
**Learning:** Flutter UI getters like `_groupedActive` are executed synchronously on every render frame. O(k*n) operations and intermediate list allocations within getters can cause frame drops on large lists.
**Action:** Replace multi-pass iterable filtering with a single-pass O(n) loop that appends directly to pre-allocated groups.
