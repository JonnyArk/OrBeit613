
## 2024-04-06 - Interactive Element Accessibility
**Learning:** Icon-only interactive elements in custom UI (like `GestureDetector`) lack screen reader context and visual cues.
**Action:** Always wrap `GestureDetector` with `Semantics(label: ..., button: true)` and `Tooltip` when lacking text labels.
