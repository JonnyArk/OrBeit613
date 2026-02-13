## 2026-02-08 - Missing Semantics on Interactive Elements
**Learning:** Flutter `GestureDetector` widgets are invisible to screen readers by default. Adding `Semantics(button: true, label: ...)` is essential for accessibility.
**Action:** Always wrap interactive icon-only elements in `Semantics`.
