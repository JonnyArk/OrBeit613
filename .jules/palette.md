## 2024-05-19 - Clickable Icon Elements in Flutter
**Learning:** Using `GestureDetector` wrapping an `Icon` is less accessible and lacks visual feedback compared to `IconButton`.
**Action:** Prefer `IconButton` (with a `tooltip` for ARIA/Semantics) over `GestureDetector` wrapping an `Icon`. For tight packing, use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` on the `IconButton`.
