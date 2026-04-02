## 2024-03-24 - Virtualizing dynamic lists

**Learning:** When using `flutter_animate` inside a virtualized, lazily-loaded list (like `ListView.builder`), item animations that use index-based delays (e.g. `delay: Duration(milliseconds: i * 40)`) cause items scrolled into view to appear frozen because the delay computation assumes the items are built sequentially at the beginning.

**Action:** Remove index-based or modulo-based animation delays for list items in virtualized lists. Items scrolled into view should animate immediately using only `duration` to avoid arbitrary UI waits.
