## 2024-10-13 - Accessible Icon Buttons
**Learning:** The app frequently uses `GestureDetector` wrapping an `Icon` for actionable elements (like completing a task or dismissing a banner), which lacks keyboard focus, semantic labels, and screen reader support.
**Action:** Replace icon-only `GestureDetector` widgets with `IconButton`, using `tooltip` for semantics, and `padding`/`constraints` to retain the original compact visual layout while natively providing full accessibility features.
