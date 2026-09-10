## 2024-09-10 - Virtualizing Heterogeneous Lists in Flutter

**Learning:** Passing pre-instantiated widgets into `ListView.builder` negates its lazy-loading performance benefits. Attempting to optimize this by eagerly building an array of closures is an anti-pattern. Eagerly generating `ListView` children elements causes O(N) widget allocations upfront.

**Action:** To correctly virtualize heterogeneous lists, use Dart 3 records (e.g., `({String type, dynamic data, int index})`) to map the data model into a flat list of items and dynamically evaluate them inside the `itemBuilder` callback. Also, cap animation stagger delays based on list position to prevent visual popping on lazily mounted items.
