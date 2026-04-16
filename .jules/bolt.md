## 2024-04-16 - Flutter Virtualized Lists
**Learning:** `ListView` pre-instantiates all its children at once. By replacing it with `ListView.builder`, we only build items when they come into the visible window, massively saving memory and improving scrolling performance on large sets of tasks.
**Action:** When working with lists that could grow dynamically and become long (like tasks), prefer `ListView.builder` over standard `ListView()`. Use a sealed class `_ListItem` to flatten nested groups into a single list while preserving the rendering boundaries and index delays.
