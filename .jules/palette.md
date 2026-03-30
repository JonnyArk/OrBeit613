## 2024-05-24 - Add ARIA tooltips and state to icon buttons
**Learning:** Found multiple instances where `GestureDetector` was used to wrap an `Icon` for a button, missing visual ripple effects, keyboard navigation, and semantic `tooltip` accessibility labels.
**Action:** Replaced icon-only `GestureDetector` widgets with `IconButton`, using `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to pack them tightly like a normal Icon, but gaining built-in Semantics and ripple states.
