## 2026-09-01 - Refactored eagerly built Flutter ListView to a lazy-loaded ListView.builder
**Learning:** Passing pre-instantiated widgets into ListView negates its lazy-loading performance benefits. Eagerly building an array of closures is an anti-pattern. Unbounded index-based animation delays cause lazily-loaded items to stay invisible upon scrolling.
**Action:** Map heterogeneous data into a flat list of Dart 3 records, dynamically evaluate items inside the itemBuilder, and cap the index multiplier for animation delays.
