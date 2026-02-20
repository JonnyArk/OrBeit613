# Palette's Journal - Critical Learnings

## 2026-02-20 - Custom Interactive Elements and Semantic Labels
**Learning:** Custom interactive widgets built with `GestureDetector` (like priority selectors and task completion buttons) are invisible to screen readers unless explicitly wrapped with `Semantics` widgets providing `button: true`, `label`, and state information (e.g., `selected`).
**Action:** Always wrap custom interactive components in `Semantics` to ensure they are accessible, even if they visually appear as buttons or toggles.
