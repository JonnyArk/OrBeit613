## 2024-04-21 - Icon-only Accessibility Pattern
**Learning:** Icon-only interactive elements using `GestureDetector` in Flutter bypass standard accessibility tree generation, making them invisible to screen readers without explicit `Semantics` wrappers, and lacking standard desktop hover clues without `Tooltip`.
**Action:** Always wrap icon-only interactive elements lacking text labels with `Semantics(label: '...', button: true)` and `Tooltip` to provide necessary accessibility metadata and visual cues.
