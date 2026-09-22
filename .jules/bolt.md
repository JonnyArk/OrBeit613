## 2024-05-24 - Virtualize ListView in task_list_panel.dart
**Learning:** Passing pre-instantiated widgets into `ListView` or `ListView(children: [...])` negates its lazy-loading performance benefits. Eagerly building all widgets upfront sacrifices performance, especially as the list grows, causing O(N) allocations instead of O(1).
**Action:** Use `ListView.builder` mapping data models to dynamic items on demand inside the `itemBuilder` callback to correctly virtualize heterogeneous lists.
