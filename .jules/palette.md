## 2026-05-27 - Replace GestureDetector with IconButton
**Learning:** Using a raw GestureDetector with an Icon for buttons lacks critical accessibility features like proper focus handling, visual ripples, and screen reader semantic labels.
**Action:** Always prefer Flutter's IconButton with the tooltip property for icon-only buttons to automatically get both visual hover context and a screen reader semantic label without manually wrapping in Semantics and Tooltip widgets.
