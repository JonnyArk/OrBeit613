# Bolt's Journal

## 2024-05-22 - [Flutter Derived State Bottleneck]
**Learning:** Found `TaskListPanel` re-computing expensive grouping logic inside `build()` method, causing frame drops during animations. Also, linear animation delays (`i * 40ms`) cause unbounded delays for large lists.
**Action:** Move derived state calculation (sorting/filtering) to `setState` or `didUpdateWidget`. Use modulo-based delays (`(i % 10) * 40ms`) for staggered animations in long lists.
