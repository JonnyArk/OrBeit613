## 2026-10-03 - Optimize long list rendering with ListView.builder
**Learning:** Using `ListView` with a `for` loop inside `children` forces Flutter to instantiate all widgets at once, bypassing virtualization. This causes significant performance issues and jank with long lists of tasks.
**Action:** Always flatten hierarchical list data structures and use `ListView.builder` or `ListView.separated` to ensure items are lazily loaded as they scroll into view.
