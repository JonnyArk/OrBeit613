## 2024-05-24 - Accessible Dismiss Buttons
**Learning:** Replacing `GestureDetector` with `IconButton` for small dismiss icons improves screen reader context (with `tooltip`) and provides keyboard focus states, but requires resetting `padding` and `constraints` to avoid breaking the existing tight visual layout.
**Action:** Always prefer `IconButton` over `GestureDetector` for icon-only actions, and use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` when retrofitting into tight layouts.
