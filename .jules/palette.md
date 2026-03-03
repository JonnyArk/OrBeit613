## 2024-05-24 - Semantic Labels for Icon-Only Buttons
**Learning:** Found several instances where `GestureDetector` wrapped an `Icon` for custom buttons (e.g., dismiss banners, complete tasks, clear dates). This lacks visual feedback (ripple effect) and more importantly, semantic labels for screen readers.
**Action:** Replace `GestureDetector` + `Icon` combinations with `IconButton`. Use the `tooltip` property to provide semantic labels for screen readers. If tight sizing is needed, use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()`.
