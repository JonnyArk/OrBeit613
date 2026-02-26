## 2026-02-17 - Virtualization in Flutter
**Learning:** Eager `ListView`s in Flutter construct all children at once, which can lead to performance issues in long lists. Converting them to `CustomScrollView` with `SliverList` and `SliverChildBuilderDelegate` enables lazy loading and significantly improves performance.
**Action:** Always prefer `ListView.builder` or `SliverList` for lists with potentially many items, and ensure `flutter_animate` delays are modulo-based to prevent unbounded delays.
