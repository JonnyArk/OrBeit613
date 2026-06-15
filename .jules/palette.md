## 2024-06-15 - Semantics for Custom Icon Buttons
**Learning:** Custom icon buttons built with `GestureDetector` in Flutter do not implicitly provide screen reader support, leaving visually impaired users without context for icon-only actions.
**Action:** Always wrap `GestureDetector` icon-only buttons in a `Semantics` widget with `button: true` and a descriptive `label` to provide ARIA-equivalent accessibility, or use native `IconButton` widgets.
