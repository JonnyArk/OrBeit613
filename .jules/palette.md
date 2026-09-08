## 2024-06-25 - Icon-only buttons accessibility in Flutter
**Learning:** In Flutter, wrapping an `Icon` with a `GestureDetector` does not implicitly provide interactive semantics to screen readers.
**Action:** Always wrap the `GestureDetector` in a `Semantics(button: true, label: '...')` widget for icon-only interactive elements.
