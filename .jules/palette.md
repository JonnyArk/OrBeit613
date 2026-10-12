## 2024-10-12 - Replace Icon-Only GestureDetector with IconButton
**Learning:** In Flutter, using `GestureDetector` around an `Icon` for interactive elements lacks native accessibility semantics (like tab focus and screen reader labels).
**Action:** Replace icon-only `GestureDetector` widgets with `IconButton`, using `tooltip` for semantics, `padding: EdgeInsets.zero`, and `constraints: const BoxConstraints()` to natively provide keyboard accessibility, focus states, and screen reader labels without altering the visual layout.
