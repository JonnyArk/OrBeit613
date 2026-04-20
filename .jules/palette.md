## 2024-05-24 - Accessibility for Icon-Only Tap Targets in Flutter
**Learning:** Icon-only interactive elements using `GestureDetector` in this Flutter app lack accessibility metadata (like ARIA labels in web) and visual hover/long-press cues, making them difficult for screen readers to interpret and reducing usability for sighted users trying to discover functionality.
**Action:** Always wrap icon-only `GestureDetector` elements with `Semantics(label: '...', button: true)` and `Tooltip(message: '...')` to provide both accessibility context and visual hints.
