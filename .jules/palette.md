## 2025-02-21 - Accessible Icon-Only Buttons
**Learning:** The OrBeit app relies heavily on custom `GestureDetector` + `Icon` combinations for its UI (like the task completion checkbox), which do not implicitly provide interactive semantics to screen readers.
**Action:** Always wrap `GestureDetector` around icon-only buttons with a `Semantics(button: true, label: '...')` widget to ensure they are properly announced by assistive technologies.
