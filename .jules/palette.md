## 2026-06-02 - Accessible Icon Buttons in Flutter
**Learning:** Using `GestureDetector` with an `Icon` for icon-only buttons lacks essential accessibility semantics, keyboard focus states, and visual tap feedback (ripples).
**Action:** Always replace `GestureDetector` + `Icon` with `IconButton`, utilizing `tooltip` for semantic labeling and adjusting `padding`/`constraints` to maintain layout dimensions.
