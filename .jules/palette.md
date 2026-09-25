## 2024-09-25 - Accessibility of icon-only GestureDetectors
**Learning:** In Flutter, wrapping an `Icon` directly with a `GestureDetector` creates an interactive element that is completely invisible to screen readers, as it lacks inherent semantic meaning.
**Action:** Always wrap `GestureDetector` widgets that contain only visual elements (like `Icon` or custom shapes) with a `Semantics` widget, explicitly setting `button: true` and providing a descriptive `label` to ensure accessibility.
