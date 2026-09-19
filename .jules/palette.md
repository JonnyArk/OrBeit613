## 2024-05-15 - Missing Semantics in GestureDetector
**Learning:** Icon-only interactive elements using `GestureDetector` lack accessibility semantics by default, making them invisible or unclear to screen readers.
**Action:** Always wrap `GestureDetector` with `Semantics(button: true, label: '...')` when used for icon-only buttons or interactive elements to ensure accessibility.
