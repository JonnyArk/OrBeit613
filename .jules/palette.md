## 2024-07-08 - Accessible Icon Buttons
**Learning:** Custom icon buttons created by wrapping an `Icon` widget in a `GestureDetector` lack proper accessibility semantics, keyboard focus, and visual tap feedback.
**Action:** Replace them with native `IconButton` widgets with appropriate tooltips. Use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to prevent layout shifts.
