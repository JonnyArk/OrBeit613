## 2024-05-24 - Interactive icons should use IconButton where possible
**Learning:** In Flutter, using `GestureDetector` with an `Icon` child for buttons lacks visual feedback (ripples), accessibility semantics, and hover effects compared to `IconButton`.
**Action:** When creating icon-only buttons, use `IconButton` instead of wrapping an `Icon` in a `GestureDetector`. If size constraints are tight, adjust `padding` and `constraints` on the `IconButton` rather than reverting to `GestureDetector`.
