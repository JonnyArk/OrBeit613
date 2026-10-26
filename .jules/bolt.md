## 2024-05-15 - Stagger Delays in Flutter Lists
**Learning:** In Flutter, avoid using index-based stagger delays (e.g., `delay: Duration(milliseconds: index * 50)`) on animations within lazily loaded list items (like those in `ListView.builder`). When scrolling, items continually re-render and re-animate out of sync, causing visual sluggishness and high CPU load.
**Action:** Remove index-based stagger delays on list items; if staggered animations are essential, manage them through a top-level animation controller or only apply them during the initial page load rather than on scroll.
