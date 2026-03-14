## 2026-03-14 - Virtualize task list rendering
**Learning:** In Flutter, using eager `ListView` with `flutter_animate` index delays causes O(N) widget building and arbitrary UI waits. `CustomScrollView` with `SliverChildBuilderDelegate` enables true lazy loading.
**Action:** Use virtualization for dynamic lists and remove index-based delays so scrolled items appear immediately.
