## 2025-02-18 - Accessibility Gaps in Custom Widgets
**Learning:** The codebase frequently uses `GestureDetector` wrapped around `Container` for interactive elements (Priority Selector, Task Tile actions, Date Picker) without any `Semantics`. This renders them invisible or confusing to screen readers.
**Action:** When creating custom interactive widgets, always wrap them in `Semantics` with `button: true` and a descriptive `label`.
