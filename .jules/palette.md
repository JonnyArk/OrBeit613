## 2024-06-12 - Icon Button Accessibility
**Learning:** Using `GestureDetector` with an `Icon` child in Flutter creates an inaccessible control that lacks semantic meaning, tab focus for keyboard users, and visual tap feedback.
**Action:** Always use native `IconButton` widgets or wrap custom icon buttons in `Semantics` widgets to ensure proper ARIA-equivalent accessibility and UX.
