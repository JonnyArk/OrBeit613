## 2024-10-10 - Flutter Virtualization
**Learning:** In Flutter, eagerly instantiating heterogeneous list elements creates memory and rendering overhead in Flutter for large lists.
**Action:** When using ListView to display large lists of varying elements (like mixed headers and list tiles), use ListView.builder with a flattened linear array of abstract data and construct the widgets dynamically on demand based on their types.
