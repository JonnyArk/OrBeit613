## 2024-09-15 - Semantics for icon-only buttons in Flutter
**Learning:** Wrapping an `Icon` with a `GestureDetector` in Flutter does not implicitly provide interactive semantics to screen readers.
**Action:** To ensure accessibility for icon-only interactive elements, always wrap the `GestureDetector` in a `Semantics(button: true, label: '...')` widget. Avoid hardcoding interaction instructions like "Tap to" in the label.
