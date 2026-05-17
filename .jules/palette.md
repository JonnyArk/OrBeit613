
## 2026-05-17 - Interactive Icon Buttons
**Learning:** Using `GestureDetector` directly on icons for tap interactions in Flutter results in a "dead" feel because it lacks hover states, focus indicators, tap ripples, and semantic accessibility labels out of the box.
**Action:** Always prefer `IconButton` (with `tooltip` and adjusted `padding`/`constraints` if tight on space) over `GestureDetector` + `Icon` to ensure rich interaction feedback, keyboard navigation, and screen reader support without needing explicit Semantics widgets.
