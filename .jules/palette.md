## 2024-05-24 - Accessible Icon Buttons
**Learning:** Using `GestureDetector` for icon-only actions drops accessibility semantics, focus states, and screen reader labels.
**Action:** Always use `IconButton` (with `tooltip`, `padding: EdgeInsets.zero`, and `constraints: const BoxConstraints()`) for icon-only actions to provide full accessibility and keyboard navigation support without altering visual layouts.
