## 2024-10-06 - Dart 3 Record Destructuring for Heterogeneous Lists
**Learning:** Dart 3's switch statement with record destructuring (`case ('active_task', final domain.Task task, final int i):`) is a safe and efficient way to map flat heterogeneous data models to widgets in `ListView.builder` without needing explicit `is` type checks.
**Action:** When virtualizing heterogeneous lists in Flutter, flatten the data models into a `List<Object>` of tuples/records and use pattern matching in the `itemBuilder` to map them to widgets.
