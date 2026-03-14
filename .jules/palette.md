# Palette's UX/A11y Learnings


## 2024-03-14 - Accessible Icon Buttons
**Learning:** Raw `GestureDetector` wrapped around an `Icon` lacks semantic labels and interaction feedback, making icon-only buttons inaccessible to screen readers.
**Action:** Prefer `IconButton` with a `tooltip` parameter. For tight layouts, use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to remove default material padding while preserving accessibility and ripple feedback.
