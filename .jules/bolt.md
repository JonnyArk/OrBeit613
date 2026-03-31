
## 2024-05-15 - Virtualization and Animation Delays
**Learning:** Virtualizing grouped data in Flutter with `ListView.builder` requires flattening nested Maps into a single array of typed wrapper objects. Additionally, when using `flutter_animate` within virtualized lists (`ListView.builder`), index-based delays cause newly scrolled items to arbitrarily wait before appearing. Delay logic must be removed for lazily loaded lists.
**Action:** Flatten heterogenous UI data before virtualization, and omit index delays in `SliverChildBuilderDelegate` or `ListView.builder` item animations.
