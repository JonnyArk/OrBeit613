## 2024-04-12 - Icon-Only Buttons Missing Semantics
**Learning:** In Flutter, icon-only interactive elements using `GestureDetector` lack necessary accessibility metadata (equivalent to missing ARIA labels) and visual cues (tooltips), making them inaccessible to screen readers.
**Action:** Always wrap icon-only `GestureDetector` buttons with `Semantics(label: '...', button: true)` and `Tooltip` to provide accessibility metadata and visual cues.
