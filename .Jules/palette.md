## 2025-02-04 - Accessibility Pattern: Custom Widget Semantics
**Learning:** Custom interactive widgets (like priority selectors built with `GestureDetector` + `Container`) are invisible to screen readers unless explicitly wrapped in `Semantics`.
**Action:** Always wrap custom interactive components in `Semantics(button: true, label: "...", child: ...)` to ensure accessibility.
