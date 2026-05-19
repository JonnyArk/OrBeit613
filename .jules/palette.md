## 2024-05-19 - Accessible Flutter Icon Buttons
**Learning:** Replaced `GestureDetector` with `IconButton` for icon-only interactions. While `GestureDetector` works visually, it lacks semantic meaning and focus states. `IconButton` provides built-in tooltips, Semantics, hover effects, and a proper tap target size.
**Action:** Always prefer `IconButton` (customizing `padding` and `constraints` to match visual designs if necessary) over raw `GestureDetector` + `Icon` to ensure immediate keyboard focusability and screen reader accessibility in Flutter applications.
