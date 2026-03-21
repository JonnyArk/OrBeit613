## 2024-05-28 - Replace GestureDetector(Icon) with IconButton
**Learning:** Using GestureDetector wrapped around an Icon for clickable elements drops semantic labels and visual feedback (ripple effect).
**Action:** Always prefer IconButton with a tooltip over GestureDetector(Icon) for accessibility and standard UX feedback. Use padding: EdgeInsets.zero and constraints: BoxConstraints() to maintain tight spacing.
