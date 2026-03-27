## 2026-03-27 - Virtualized Lists & Staggered Animations
**Learning:** Virtualizing heterogeneous Flutter lists with `ListView.builder` requires flattening the data into a wrapper class. Additionally, using index-based `delay` with `flutter_animate` inside a lazy builder causes scrolled items to wait arbitrarily before appearing, resulting in visual stuttering.
**Action:** Always flatten grouped data into an explicit enum-based wrapper (e.g., `_TaskListItemType`) for `ListView.builder`, and remove staggered delays on lazily loaded items so they animate immediately upon scrolling into view.
