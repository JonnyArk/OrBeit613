## 2024-05-31 - Use IconButton for Icon-Only Tap Targets
**Learning:** In Flutter, wrapping an `Icon` in a `GestureDetector` deprives the element of critical interaction feedback (like tap ripples) and screen reader support.
**Action:** Replace `GestureDetector` + `Icon` combinations with `IconButton`, using `constraints` and `padding` adjustments, to natively gain tooltips, visual feedback, and semantic labels.
