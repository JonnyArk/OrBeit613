## 2024-06-03 - Replace GestureDetector with IconButton for Icon-Only Buttons
**Learning:** Found custom icon-only buttons using GestureDetector without semantic labels, tooltips, or focus states in the task list panel.
**Action:** Always prefer IconButton over GestureDetector for standalone icons to automatically gain hover tooltips, visual tap ripples, and screen reader semantic labels. If size constraints exist, adjust padding and constraints on IconButton instead of falling back to GestureDetector.
