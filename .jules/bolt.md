## 2025-02-18 - Heterogeneous lists in Flutter
**Learning:** Using `ListView` eagerly instantiates all children, but creating a `ListView.builder` for heterogeneous lists requires index math.
**Action:** Map the data into a list of lightweight closures (`List<Widget Function()>`) inside `build()` to preserve lazy evaluation while keeping readable iterative logic.
