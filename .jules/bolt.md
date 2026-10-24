## 2026-10-24 - Avoid stagger delays in Flutter lazily loaded list items
**Learning:** Using index-based stagger delays (e.g., `delay: Duration(milliseconds: i * 40)`) on animations within lazily loaded list items (like those in `ListView.builder` or `ListView` containing dynamically generated children based on an index logic) can cause visual sluggishness during scrolling.
**Action:** Remove index-based stagger delays in list views to improve performance and remove the visual sluggishness when scrolling lazily evaluated items.
