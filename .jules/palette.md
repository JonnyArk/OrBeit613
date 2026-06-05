## 2024-06-05 - Use IconButton for Icon-Only Buttons
**Learning:** Icon-only buttons implemented with `GestureDetector` lack important accessibility semantics (like screen-reader labels and focus indicators) and UX features (like hover/ripple states).
**Action:** Replace `GestureDetector` + `Container` + `Icon` patterns with `IconButton` and provide a meaningful `tooltip` parameter. Add `padding` and `constraints: const BoxConstraints()` to closely mimic previous custom sizing if necessary.
