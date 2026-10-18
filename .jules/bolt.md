## 2023-10-18 - Avoid index-based stagger delays in list builders
**Learning:** Using index-based stagger delays (e.g., `delay: Duration(milliseconds: i * 40)`) on animations within lazily loaded list items (like those in `ListView.builder`) causes visual sluggishness during scrolling in Flutter.
**Action:** Remove index-based delays from animations on list items.