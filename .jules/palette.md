## 2024-05-30 - Replace icon-only GestureDetector with IconButton
**Learning:** In Flutter, using an icon-only `GestureDetector` lacks native keyboard accessibility, focus states, clear tap feedback, and screen reader labels.
**Action:** Replace icon-only `GestureDetector` widgets with `IconButton` using `tooltip` for semantics, `padding: EdgeInsets.zero`, `constraints: const BoxConstraints()`, and an appropriate `splashRadius` (e.g., `16`) to improve accessibility without altering the visual layout.
