## 2024-05-24 - Interactive Icon Accessibility
**Learning:** Wrapped Icons in GestureDetectors in Flutter do not implicitly provide interactive semantics to screen readers.
**Action:** When adding onTap behavior to icons without wrapping in standard buttons (like IconButton), always wrap the GestureDetector in a Semantics(button: true, label: '...') widget to ensure screen readers announce them as interactive buttons.
