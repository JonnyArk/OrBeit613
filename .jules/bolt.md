## 2024-09-11 - Heterogeneous list virtualization in Flutter
**Learning:** Using `ListView` with a pre-built list of children causes O(N) widget allocations upfront. Eagerly evaluating list items inside `ListView` instead of `ListView.builder` hurts performance, especially as lists grow.
**Action:** When mapping heterogeneous data models for `ListView.builder` in Dart/Flutter, use Dart 3 records (e.g., `({String type, dynamic data, int index})`) to create a flat list of items to dynamically evaluate them inside the `itemBuilder`.
