## 2024-05-24 - [Use IconButton over GestureDetector for Icons]
**Learning:** For clickable icon elements in Flutter, wrapping an `Icon` in a `GestureDetector` lacks proper accessibility labels and visual feedback.
**Action:** Prefer using `IconButton` with a `tooltip` for semantic labels. Use `padding` and `constraints: const BoxConstraints()` for tight packing if replacing a `Container`.
