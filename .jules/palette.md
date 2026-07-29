## YYYY-MM-DD - Accessible Icon Buttons in Flutter
**Learning:** Using `IconButton` instead of `GestureDetector` for small icons provides better UX (ripple effect) and built-in accessibility (via `tooltip`), but its default padding can break dense UI layouts.
**Action:** When replacing a `GestureDetector` with an `IconButton` in constrained spaces, explicitly set `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to preserve the original visual layout.
