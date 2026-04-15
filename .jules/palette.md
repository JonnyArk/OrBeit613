## 2026-04-15 - Missing Semantics on Custom Icon Buttons
**Learning:** This app heavily uses `GestureDetector` + `Icon` instead of `IconButton` for custom styling. This pattern completely drops native accessibility labels and tooltips, making icon-only interactions invisible to screen readers.
**Action:** Always manually wrap icon-only `GestureDetector` widgets with `Semantics(button: true, label: '...')` and `Tooltip` to restore expected a11y and UX affordances.
