## 2024-10-27 - Icon Accessibility
**Learning:** Found an accessibility issue pattern where `GestureDetector` is used with icon-only widgets instead of `IconButton`, resulting in missing semantic labels for screen readers and no keyboard focus support.
**Action:** Replace `GestureDetector` with `IconButton` using `tooltip` for semantics, `padding: EdgeInsets.zero`, and `constraints: const BoxConstraints()` to improve accessibility without altering visual layout.
