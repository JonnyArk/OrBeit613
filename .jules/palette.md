## 2024-09-20 - Accessible Icon-Only Buttons
**Learning:** In Flutter, wrapping an `Icon` with a `GestureDetector` does not implicitly provide interactive semantics to screen readers.
**Action:** Always wrap custom icon-only interactive elements in a `Semantics(button: true, label: '...')` widget. Avoid hardcoding interaction verbs (e.g., 'Tap to') in the label, as screen readers announce them automatically.
