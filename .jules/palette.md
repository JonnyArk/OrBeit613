
## 2025-02-24 - Add Semantics and Tooltips to Icon-Only GestureDetectors
**Learning:** Discovered a recurring pattern in the app where icon-only `GestureDetector` widgets are used for buttons (e.g., "Complete task" checkboxes) without `Semantics` or `Tooltip` wrappers, making them inaccessible to screen readers and lacking hover cues.
**Action:** Always wrap icon-only interactive elements in `Semantics(label: '...', button: true)` and a `Tooltip` widget to ensure both accessibility metadata and visual hover states are present.
