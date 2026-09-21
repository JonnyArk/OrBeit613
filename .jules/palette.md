## 2024-05-24 - Semantics for Icon-Only Buttons
**Learning:** In Flutter, wrapping an `Icon` with a `GestureDetector` does not implicitly provide interactive semantics to screen readers. Screen readers will not announce the interactive element or its purpose.
**Action:** Always wrap `GestureDetector` elements that act as icon-only buttons with a `Semantics` widget, setting `button: true` and providing a clear, concise `label`. Avoid hardcoding interaction instructions in the hint, as screen readers automatically provide appropriate verbs.
