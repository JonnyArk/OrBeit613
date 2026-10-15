## 2024-10-15 - Icon-Only Accessibility Pattern
**Learning:** Replaced multiple instances of `GestureDetector` containing only an `Icon` widget with `IconButton` in the Flutter UI. The original pattern lacked accessibility metadata (screen reader labels) and visual feedback (ink splash, focus indicators).
**Action:** Always prefer `IconButton` (using `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` if strict sizing is needed) over `GestureDetector` for icon-only interactions to ensure keyboard accessibility and proper semantics out of the box.
