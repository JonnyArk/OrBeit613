
## 2026-06-06 - Reminder Banner Close Button
**Learning:** Icon-only close buttons wrapped in GestureDetector lack semantic meaning for screen readers and miss native interaction feedback.
**Action:** Always prefer `IconButton` with a `tooltip` over `GestureDetector` + `Icon` for standalone actions to ensure automatic accessibility labeling, focus rings, and ripple feedback, overriding `padding` and `constraints` to maintain compact layouts.
