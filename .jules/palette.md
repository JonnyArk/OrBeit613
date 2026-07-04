## 2026-07-04 - Accessible Custom Icon Buttons
**Learning:** Wrapping an `Icon` widget in a `GestureDetector` lacks proper accessibility semantics, keyboard focus, and visual tap feedback.
**Action:** Replace `GestureDetector` + `Icon` combinations with native `IconButton` widgets, providing a `tooltip` attribute for screen readers. Set `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to prevent default sizing from breaking layout.
