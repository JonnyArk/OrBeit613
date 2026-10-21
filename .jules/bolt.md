## 2024-10-21 - Index-based Stagger Delays in Lists
**Learning:** Using index-based delays for list item animations (e.g., `delay: Duration(milliseconds: index * 50)`) inside scroll views like `ListView.builder` causes severe visual sluggishness and bugs on long lists, as items scrolled into view later will wait their full index-derived delay (sometimes seconds) before appearing.
**Action:** Avoid index-based stagger delays on list items entirely in Flutter scroll views. Use a fixed delay or specialized list animation libraries that handle viewport-based staggering correctly.
