## 2024-07-20 - Make task completion button accessible
**Learning:** Icon-only interactive elements like `GestureDetector` in task lists lack screen reader context, hindering accessibility.
**Action:** Replaced `GestureDetector` with an `IconButton` using `tooltip` and adjusted padding/constraints to maintain visual layout without breaking accessibility.
