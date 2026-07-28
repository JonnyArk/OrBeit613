
## YYYY-MM-DD - Interactive Icon Buttons in Tight Layouts
**Learning:** Using `GestureDetector` for icon-only buttons severely degrades accessibility by lacking a semantic label, keyboard focus states, and interaction feedback (like a hover or ripple effect).
**Action:** Replace `GestureDetector` with `IconButton` and explicitly set `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to gain accessibility and interaction states without altering the surrounding tight visual layout. Always include a `tooltip` for screen readers.
