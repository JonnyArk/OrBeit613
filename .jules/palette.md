## 2024-10-20 - Accessible Icon Buttons in Flutter
**Learning:** Replaced icon-only `GestureDetector` widgets with `IconButton` using `tooltip` for semantics, `padding: EdgeInsets.zero`, and `constraints: const BoxConstraints()` to provide native keyboard accessibility, focus states, and screen reader labels.
**Action:** Use `IconButton` instead of `GestureDetector` for single icons when they need to be interactive.
