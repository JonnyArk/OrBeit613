## 2024-05-14 - Animation Delay in Virtualized Lists
**Learning:** Using `flutter_animate` inside a virtualized, lazily-loaded list (e.g., `ListView.builder` or `SliverChildBuilderDelegate`) with index-based or modulo-based animation delays causes arbitrary UI waits when scrolling.
**Action:** Remove index-based or modulo-based animation delays for items in virtualized lists. Items scrolled into view should animate immediately using only `duration`.
