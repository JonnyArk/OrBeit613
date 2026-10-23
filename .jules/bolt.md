## 2026-10-23 - Index-based Stagger Delays in Lazy Lists
**Learning:** Using index-based stagger delays (e.g., `delay: Duration(milliseconds: i * 50)`) on animations within lazily loaded list items (like `ListView.builder` or `ListView`) can cause visual sluggishness during scrolling, because the delay grows indefinitely for items further down the list.
**Action:** Remove index-based staggered delays from items inside lazily built lists, using constant animation durations or avoiding index-dependent staggering to ensure smooth scrolling performance.
