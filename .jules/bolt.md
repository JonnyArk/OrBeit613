## 2024-05-24 - Virtualizing Heterogeneous Lists in Flutter
**Learning:** Using an eager `ListView` for grouped lists with section headers and items causes all items to be pre-instantiated in memory, which degrades performance for large lists.
**Action:** Flatten the grouped data structure into a single array of wrapped objects with an explicit type enum (e.g., `_TaskListItemType`). Then use `ListView.builder` to dynamically render the correct widget per index, enabling true virtualization.
