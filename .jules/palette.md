## 2024-05-15 - Interactive Icon Accessibility
**Learning:** Icon-only interactive elements wrapped in `GestureDetector` do not implicitly provide interactive semantics to screen readers in Flutter.
**Action:** Wrap the `GestureDetector` in a `Semantics(button: true, label: '...')` widget.
