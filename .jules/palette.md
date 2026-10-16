## 2024-10-16 - Accessible Icon Buttons in Flutter
**Learning:** Icon-only `GestureDetector` widgets lack keyboard accessibility, focus states, and screen reader labels.
**Action:** Replace icon-only `GestureDetector` widgets with `IconButton`, using `tooltip` for semantics, `padding: EdgeInsets.zero`, and `constraints: const BoxConstraints()` to natively provide keyboard accessibility, focus states, and screen reader labels without altering the visual layout.
