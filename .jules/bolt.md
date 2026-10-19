## 2024-10-19 - Index-based Delays in Lazy Lists
**Learning:** Using index-based stagger delays (e.g., `delay: Duration(milliseconds: index * 50)`) inside lazily evaluated Flutter lists like `ListView.builder` causes visual sluggishness during scrolling because items rendered later receive increasingly long animation delays, breaking the illusion of smooth performance.
**Action:** Remove index-based delays on animations within `ListView.builder` or other lazily built widgets to ensure items appear immediately when scrolled into view.
