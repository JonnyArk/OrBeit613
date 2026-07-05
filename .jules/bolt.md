## 2026-07-05 - ListView.builder Staggered Animation Jank
**Learning:** When refactoring an eagerly-instantiated `ListView` to `ListView.builder` in Flutter, you must remove index-based staggered entrance animations. If left in, items scrolling into view will inappropriately trigger entrance delays, causing visual regressions and scroll jank.
**Action:** Always strip index-based delays from entrance animations when implementing lazy loading.
