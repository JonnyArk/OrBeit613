## 2026-05-20 - Use IconButton instead of GestureDetector for icon-only buttons
**Learning:** Using `GestureDetector` wrapped around an `Icon` for a button lacks semantic meaning, focus states, and visual feedback (ripples). This is a common accessibility trap in Flutter apps.
**Action:** Always prefer `IconButton` (adjusting `padding` and `constraints` as needed) with the `tooltip` property set for icon-only buttons to automatically handle tap ripples, focus indicators, and screen reader semantic labels.
