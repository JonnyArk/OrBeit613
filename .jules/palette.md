## 2024-05-24 - Missing Accessibility on Icon Buttons
**Learning:** Found a recurring pattern in the Flutter app where interactive elements are built using raw `GestureDetector` directly wrapping an `Icon`, resulting in elements that screen readers cannot identify and missing visual hover/tooltip cues.
**Action:** Always wrap these raw `GestureDetector` + `Icon` patterns in `Semantics(label: '...', button: true)` and `Tooltip(message: '...')` to ensure accessibility and micro-UX polish without disrupting layout.
