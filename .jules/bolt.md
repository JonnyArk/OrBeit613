## 2024-10-31 - Avoid index-based delays in ListView.builder animations
**Learning:** Using index-based stagger delays (e.g., `delay: Duration(milliseconds: index * 50)`) on animations inside lazily loaded list items like `ListView.builder` causes visual sluggishness and performance issues during scrolling.
**Action:** Avoid index-based stagger delays in lazily loaded lists. Use a constant small delay or stagger animations based on an initial load sequence rather than scrolling.
