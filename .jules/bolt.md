## 2024-10-28 - Removed Index-Based Animation Delays in List Builders
**Learning:** In Flutter, avoid using index-based stagger delays (e.g., delay: Duration(milliseconds: index * 50)) on animations within lazily loaded list items (like those in ListView.builder), as this can cause visual sluggishness during scrolling.
**Action:** Avoid index-based stagger delays on items rendered inside lazily evaluated builders like ListView.builder.
