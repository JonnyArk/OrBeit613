## 2026-10-15 - Optimize ListView animations
**Learning:** Index-based stagger delays (e.g., delay: Duration(milliseconds: i * 40)) on animations within lazily loaded list items cause visual sluggishness during scrolling in Flutter. This is specifically called out in memory constraints.
**Action:** Remove index-based delays from animate() calls inside ListViews and lazily loaded lists to ensure smooth scrolling performance.
