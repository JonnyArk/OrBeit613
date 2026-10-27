## 2024-10-27 - Remove index-based stagger delay in lazy lists
**Learning:** Using index-based stagger delays (e.g., `delay: Duration(milliseconds: i * 50)`) on animations within lazily loaded list items like `ListView.builder` can cause visual sluggishness during scrolling because elements are eagerly animated with cumulative delays as they scroll into view.
**Action:** Avoid index-based stagger delays in lazily loaded builders; instead, rely on simple entry animations or use specialized stagger list view packages.
