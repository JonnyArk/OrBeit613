## 2024-05-14 - Accessibility for icon-only interactives in Flutter
**Learning:** Found an accessibility pattern for Flutter interactive elements like `GestureDetector` that are icon-only. They need a `Semantics` wrapper with `label` and `button` properties to make them readable by screen readers, along with a `Tooltip` to visually explain what the icon does.
**Action:** Always wrap icon-only `GestureDetector` elements (like close buttons, priority selectors, clear actions) with `Semantics(label: '...', button: true)` and a `Tooltip(message: '...')` if visual feedback is missing.
