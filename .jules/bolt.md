## 2024-05-23 - Lazy loading heterogeneous lists in Flutter
**Learning:** Passing pre-instantiated widgets into `ListView` causes O(N) upfront allocations, negating performance benefits for long lists.
**Action:** Always map varied data models into a flat list of Dart 3 records (`({String type, dynamic data, int index})`) and evaluate them dynamically in `ListView.builder`. Cap staggered animations conditionally (e.g., `index < 10`) to prevent visual popping on lazily mounted items.
