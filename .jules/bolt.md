## 2024-04-28 - Virtualizing Long Lists
**Learning:** Grouped and flattened task lists should use `ListView.builder` instead of standard `ListView` to prevent off-screen widget construction, saving significant memory and compute during rendering. Dart 3 sealed classes are an excellent pattern for modeling the heterogenous items.
**Action:** Use `ListView.builder` with a single flattened state array mapping items to `sealed class` list models, applying switch expressions for the view builder.
