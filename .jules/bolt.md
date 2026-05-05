## 2024-05-24 - Virtualized Task List

**Learning:** When dealing with potentially large lists in Flutter, using standard `ListView` with a predefined list of children forces the framework to build every widget upfront. If lists grow large, this causes frame drops and high memory usage, especially when paired with complex animations or nested widgets like `Dismissible`.

**Action:** Refactor long lists, such as the active tasks in `TaskListPanel`, to use `ListView.builder`. When flattening grouped items to map correctly to `itemBuilder` indices, create a sealed union type (e.g., `_TaskListItem`) to represent either headers or task tiles. This ensures items are lazily built, preserving performance regardless of list size.
