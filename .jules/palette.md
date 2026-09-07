## 2025-02-12 - Accessibility semantics for interactive icons in Flutter
**Learning:** Wrapping an Icon with a GestureDetector does not implicitly provide interactive semantics to screen readers.
**Action:** Always wrap icon-only interactive elements (GestureDetectors) in a Semantics(button: true, label: '...') widget to ensure accessibility.
