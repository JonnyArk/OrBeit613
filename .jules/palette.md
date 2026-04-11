
## 2026-04-11 - Semantics and Tooltips for Icon-Only Buttons
**Learning:** Icon-only interactive elements using `GestureDetector` in Flutter lack accessibility metadata and visual cues, making them difficult for screen readers and keyboard users to navigate.
**Action:** Always wrap icon-only `GestureDetector` widgets with `Semantics(label: '...', button: true)` and `Tooltip(message: '...')` to ensure they are accessible and provide clear visual context.
