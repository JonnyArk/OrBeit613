## 2024-10-14 - Remove index-based stagger delays in list views
**Learning:** Using index-based stagger delays (e.g., `delay: Duration(milliseconds: index * 50)`) on animations within lazily loaded lists (like `ListView.builder`) causes severe visual sluggishness during scrolling, as later items receive massive delays.
**Action:** Avoid index-based stagger delays in scrollable lists; use constant delays or remove them completely for instantly responsive list items.
