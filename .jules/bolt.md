
## 2025-02-28 - Optimized TaskListPanel in Flutter
**Learning:** Flutter's `build` method is called frequently, and executing complex filtering or grouping (e.g., `tasks.where(...)`) directly within it or via getters accessed during build can cause CPU overhead and jank.
**Action:** Move expensive data transformations out of the `build` path. Compute them once when the data changes (e.g., in a `_processTasks()` method called after `setState`) and store the results in state variables to be read instantly during rendering. Also, when using staggered animations in large lists, use a modulo approach for delays (`delay: Duration(milliseconds: (index % 10) * 40)`) to prevent unbounded wait times for items further down the list.
