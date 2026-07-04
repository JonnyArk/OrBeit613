## 2026-07-04 - Optimizing Eager Lists in Flutter
**Learning:** In Flutter, passing pre-instantiated widgets into ListView.builder negates its lazy-loading performance benefits. To correctly optimize heterogeneous lists, flatten the data into lightweight data structures (e.g., an array of maps) and dynamically instantiate the widgets inside the itemBuilder callback based on the item type.
**Action:** Always flatten data structures when using ListView.builder for heterogeneous content, and remove index-based entrance delays to prevent scroll jank when items are scrolled into view.
