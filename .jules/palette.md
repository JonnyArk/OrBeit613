## 2026-09-09 - Semantics for Icon-only Interactive Elements in Flutter
**Learning:** Wrapping an `Icon` with a `GestureDetector` in Flutter does not implicitly provide interactive semantics to screen readers.
**Action:** Always wrap the `GestureDetector` in a `Semantics(button: true, label: '...')` widget to ensure accessibility for icon-only interactive elements. Avoid hardcoding interaction instructions like "Tap to" in the label as screen readers announce this automatically.
