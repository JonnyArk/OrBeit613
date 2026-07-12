## YYYY-MM-DD - Replacing GestureDetector with IconButton for accessible micro-interactions
**Learning:** Using `GestureDetector` for icon buttons in Flutter lacks built-in semantics, keyboard focus states, hover effects, and tooltips, which degrades accessibility and user experience.
**Action:** Use `IconButton` instead of `GestureDetector` for small interactive icons, and set `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to prevent layout shifts while gaining a11y benefits and `tooltip` support.
