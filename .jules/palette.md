## 2024-05-24 - Accessibility for Icon-Only Tap Targets
**Learning:** In Flutter, using a raw `GestureDetector` around an `Icon` creates an interactive element that is invisible to screen readers and lacks visual hover/focus cues.
**Action:** Always wrap icon-only interactive elements with `Semantics(label: '...', button: true)` and `Tooltip` to ensure both accessibility metadata and visual feedback are present.
