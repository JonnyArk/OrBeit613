## 2024-05-23 - Accessibility semantics for icon buttons in Flutter
**Learning:** Custom icon buttons created by wrapping an `Icon` widget in a `GestureDetector` lack proper accessibility semantics, keyboard focus, and visual tap feedback.
**Action:** Replace them with native `IconButton` widgets (providing a `tooltip` attribute for screen readers), and set `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to prevent the `IconButton`'s default sizing from breaking the surrounding visual layout.
