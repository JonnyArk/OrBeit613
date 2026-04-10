## 2024-05-24 - Animation Delays in Virtualized Lists
**Learning:** Using index-based delays for list item animations (e.g., `delay: Duration(milliseconds: index * 50)`) in virtualized Flutter lists (`ListView.builder` or `ListView`) causes items scrolled into view to wait arbitrarily before appearing.
**Action:** Remove index-based or modulo-based animation delays when using `flutter_animate` inside lazily loaded or virtualized lists. Scroll animations should be immediate, using only `duration`.
