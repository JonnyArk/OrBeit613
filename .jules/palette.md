## 2026-09-02 - Missing Semantics on Icon-Only GestureDetectors
**Learning:** In Flutter, unlike `IconButton`, wrapping an `Icon` with a `GestureDetector` does not implicitly provide interactive semantics to screen readers. This leaves icon-only interactive elements completely invisible to accessibility services.
**Action:** Always wrap icon-only `GestureDetector` widgets in a `Semantics(button: true, label: '...')` widget to ensure screen readers can navigate and activate them.
