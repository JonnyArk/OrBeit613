## 2024-05-24 - Avoid Index-Based Stagger Delays in Flutter Lists
**Learning:** Using index-based stagger delays (e.g., delay: Duration(milliseconds: index * 50)) on animations inside lazily loaded list items (ListView.builder) causes severe visual sluggishness and missing items when scrolling, as items deep in the list will have massive, compounding delay times before they begin rendering.
**Action:** Never use index-based staggered delays for items in scrollable lists; rely on default immediate animations or track view-port intersection for controlled entry animations instead.
