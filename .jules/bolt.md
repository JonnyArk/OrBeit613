## 2024-04-23 - Flattening lists for ListView.builder in Flutter
**Learning:** Using standard `ListView` with nested loops and components (via spread operators `...[]`) for hierarchical layouts works, but it breaks Flutter's virtualization because all elements are built synchronously at once.
**Action:** When refactoring nested `ListView` structures to `ListView.builder` for performance, map the nested structure to a 1D array using Dart 3 sealed classes. Add an explicit localized index property to maintain original visual behaviors like staggered animation delays accurately.
