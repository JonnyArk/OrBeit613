## YYYY-MM-DD - Accessible Icon Buttons in Flutter
**Learning:** Replacing raw `GestureDetector` widgets wrapping `Icon`s with `IconButton` significantly improves accessibility by providing semantic labels (tooltips), focus states, and interaction feedback (ink splashes). However, default `IconButton` constraints can break tight visual layouts.
**Action:** When migrating `GestureDetector` icons to `IconButton` for accessibility, explicitly set `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to preserve the original visual footprint while gaining a11y benefits.
