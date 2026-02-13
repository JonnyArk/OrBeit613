## 2026-02-13 - [Flutter Derived State Performance]
**Learning:** Recalculating derived state (filtering lists, grouping) inside Flutter `build` methods can lead to performance degradation (O(N*M) per frame) if the list is large or the build is frequent (e.g., animations).
**Action:** Memoize derived state in `setState` updates or using `memo` equivalent, calculating it only when the source data changes.
