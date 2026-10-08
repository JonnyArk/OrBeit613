## 2024-05-24 - Accessible Icon Buttons in Flutter
**Learning:** Icon-only `GestureDetector` widgets in Flutter lack keyboard accessibility, focus states, and screen reader labels.
**Action:** Always replace icon-only `GestureDetector` widgets with `IconButton`, utilizing the `tooltip` property for semantics, and `padding: EdgeInsets.zero` with `constraints: const BoxConstraints()` to maintain the original visual layout.
