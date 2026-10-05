## 2024-10-05 - Replace Icon-only GestureDetector with IconButton
**Learning:** Icon-only `GestureDetector` widgets in Flutter lack native keyboard accessibility, focus states, and screen reader labels.
**Action:** In Flutter, replace icon-only `GestureDetector` widgets with `IconButton` (using `tooltip` for semantics, `padding: EdgeInsets.zero`, and `constraints: const BoxConstraints()`) to natively provide keyboard accessibility, focus states, and screen reader labels without altering the visual layout.
