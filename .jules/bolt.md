## 2024-06-25 - Avoid eagerness in heterogenous task lists
**Learning:** Using `ListView` with a large number of eagerly built items can cause performance regressions, especially in flutter where long lists can cause main thread blocking. Attempting to optimize this by eagerly building an array of closures is an anti-pattern.
**Action:** Always map heterogeneous list data into a flat list of Dart 3 records (e.g., `({String type, dynamic data, int index})`) and use `ListView.builder` for efficient lazy-loading, ensuring staggered animation delays are capped to prevent visual popping.
