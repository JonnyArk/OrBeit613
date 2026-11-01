## 2024-05-24 - Flatten heterogeneous lists for ListView.builder in Flutter
**Learning:** `ListView(children: [...])` synchronously evaluates and builds all children widgets, which causes performance issues when the list grows.
**Action:** In Flutter, when using `ListView.builder` to optimize heterogeneous lists (e.g., mixing headers and task items), map the data into a list of lightweight closures (e.g., `List<Widget Function()>`) to be called by `itemBuilder`, preserving lazy evaluation without eagerly instantiating the widgets.
