## 2026-07-01 - ListView.builder Staggered Animation Bug
**Learning:** In Flutter, when refactoring an eagerly-instantiated list (e.g., ListView with a children array) to use lazy loading (e.g., ListView.builder), you must remove or adjust index-based staggered entrance animations on the list items (e.g., delay: Duration(milliseconds: i * 40)). If left in, items scrolling into view will inappropriately trigger entrance delays, causing visual regressions and scroll jank.
**Action:** Always remove index-based delays when converting lists to ListView.builder.
