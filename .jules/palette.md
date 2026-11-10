## 2026-03-24 - Accessibility improvements for icon buttons
**Learning:** Replaced icon-only `GestureDetector` widgets with `IconButton` using `tooltip` for semantics, removing padding, and adding a `splashRadius` provides native keyboard accessibility, focus states, clear tap feedback, and screen reader labels.
**Action:** Always prefer `IconButton` with `tooltip` for icon-only buttons instead of `GestureDetector` to improve accessibility without altering visual layout.
