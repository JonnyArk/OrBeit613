## 2024-05-16 - Icon-Only Button Accessibility
**Learning:** Icon-only buttons wrapped in `GestureDetector` in Flutter are completely opaque to screen readers and lack visual context for pointer device users.
**Action:** Always wrap these elements in both `Semantics(label: '...', button: true)` for screen readers and `Tooltip(message: '...')` for visual hover context to ensure comprehensive accessibility.
