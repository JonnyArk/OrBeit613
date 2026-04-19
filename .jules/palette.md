## 2026-04-19 - Semantics and Tooltips for Icon-only Buttons
**Learning:** Icon-only interactive elements using `GestureDetector` lack accessibility metadata and visual hover cues by default.
**Action:** Always wrap icon-only `GestureDetector` widgets with `Semantics(label: '...', button: true)` and `Tooltip` to provide proper screen reader support and visual feedback on hover.
